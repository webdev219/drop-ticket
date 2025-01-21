require 'discordrb'

class DiscordBotService
  BOT_TOKEN = Rails.application.credentials.config[:discord][:token]
  CLIENT_ID = Rails.application.credentials.config[:discord][:client_id]
  CHANNEL_ID = 1328014476993368213
  USER_ID=1312259562384003092

  def self.run
    @default_params = {country_code: ['US'], state: 'CA', city: nil, keyword: ['Music']}
    @bot_params = {}
    bot = Discordrb::Commands::CommandBot.new token: BOT_TOKEN, prefix: '!'
    bot.command(:exit, help_available: false) do |event|
      break unless event.user.id == USER_ID

      bot.send_message(event.channel.id, 'Bot is shutting down')
      exit
    end

    bot.command(:monitor, help_available: true) do |event, *args|
      params = @bot_params[event.user.id] || @default_params.dup
      params[:channel_id] = event.channel.id
      @bot_params[event.user.id] = params
      DiscordBotComponentService.add_countries(params)
    end
    
    bot.command(:stop, help_available: true) do |event|
      UserOption.find_by(discord_id: event.user.id).update(monitor: false)
      bot.send_message(event.channel.id, 'Stop the monitoring of ticket events.')
    end

    bot.button(custom_id: 'country') do |event|
      event.respond(content: 'You selected country')
      params = @bot_params[event.user.id] || @default_params.dup
      params[:channel_id] = event.channel.id
      @bot_params[event.user.id] = params
      DiscordBotComponentService.add_countries(params)
    end

    bot.select_menu(custom_id: 'country_code') do |event|
      event.respond(content: 'You selected country')
      params = @bot_params[event.user.id] || @default_params.dup
      params[:channel_id] = event.channel.id
      params[:country_code] = event.values
      @bot_params[event.user.id] = params
      DiscordBotComponentService.add_keyword(params)
    end
    
    bot.button(custom_id: 'keyword') do |event|
      event.respond(content: 'You selected keyword')
      params = @bot_params[event.user.id] || @default_params.dup
      params[:channel_id] = event.channel.id
      bot.add_await!(Discordrb::Events::MessageEvent, timeout: 60) do |response_event|
        keyword = response_event.message.content.strip.split(" ")
        params[:keyword] = keyword
        @bot_params[event.user.id] = params
        DiscordBotComponentService.add_keyword(params)
        true
      end
    end

    bot.button(custom_id: 'monitor') do |event|
      event.respond(content: 'Monitoring for event tickets!')
      option = UserOption.find_or_create_by(discord_id: event.user.id)
      option.update(options: @bot_params[event.user.id], sent_at: Time.zone.now-2.hours)
      self.send_event_message(option)
    end

    bot.message do |event|
      self.handle_message(event)
    end

    bot.send_message(CHANNEL_ID, 'Started bot!')

    bot.run
  end

  def self.handle_message(event)
    user_message = event.message.content
    if user_message.downcase == 'hello'
      event.respond 'Hello there, what do you want?'
    end
  end

  def self.send_event_message(option)
    bot    = Discordrb::Bot.new token: BOT_TOKEN
    user   = bot.user(option.discord_id)
    
    events = TicketService.get_events(option.event_params)
    price  = ->(ticket) { ticket.min_price == ticket.max_price ? "$#{ticket.max_price}" : "$#{ticket.min_price} ~ $#{ticket.max_price}" }
    index  = 0
    loop do
      break if index > events.count - 1
      ticket = events[index]
      message = 
        <<~EVENT_MESSAGE
          Name: #{ticket.event_name}
          Price: #{price.call(ticket) if ticket.min_price.present?}
          Event URL:#{ticket.primary_event_url}
          Event Time: #{ticket.event_start_local_date.strftime("%a • %b %m, %y")} #{ticket.event_start_local_time.strftime("• %-I:%M %p") rescue nil}
        EVENT_MESSAGE
      user.dm(message)
      index += 1
      sleep(1)
    end
  end
end
