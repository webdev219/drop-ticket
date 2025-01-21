require 'discordrb'

class DiscordBotService
  BOT_TOKEN = Rails.application.credentials.config[:discord][:token]
  CLIENT_ID = Rails.application.credentials.config[:discord][:client_id]
  CHANNEL_ID = 1328014476993368213
  USER_ID=1312259562384003092

  def self.run
    @default_params = {country_code: ['US'], state: 'CA', city: nil, keyword: 'Music'}
    @bot_params = {}
    bot = Discordrb::Commands::CommandBot.new token: BOT_TOKEN, prefix: '!'
    bot.command(:exit, help_available: false) do |event|
      break unless event.user.id == USER_ID

      bot.send_message(event.channel.id, 'Bot is shutting down')
      exit
    end

    bot.command(:hi, help_available: true) do |event|
      bot.send_message(event.channel.id, 'Hi, I am a bot for getting all tickets')
    end

    bot.command(:test, help_available: true) do |event|
      bot.send_message(event.channel.id, 'I am ready to get all tickets.')
    end

    bot.command(:events, help_available: true) do |event, *args|
      params = @bot_params[event.user.id] || @default_params.dup
      params[:channel_id] = event.channel.id
      @bot_params[event.user.id] = params
      DiscordBotComponentService.add_countries(params)
    end

    bot.command(:keyword, help_available: true) do |event, *args|
      params = @bot_params[event.user.id] || @default_params.dup
      params[:channel_id] = event.channel.id
      @bot_params[event.user.id] = params
      DiscordBotComponentService.add_keyword(params)
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
      bot.add_await!(Discordrb::Events::MessageEvent, timeout: 30) do |response_event|
        keyword = response_event.message.content.strip
        params[:keyword] = keyword
        @bot_params[event.user.id] = params
        DiscordBotComponentService.add_keyword(params)
        true
      end
    end


    bot.button(custom_id: 'search') do |event|
      event.respond(content: 'Looking for tickets!')
      events = TicketService.get_events(@bot_params[event.user.id])
      event.channel.send_message("There are no events for the keyword '#{@bot_params}'.") if events.count.zero?

      price = ->(ticket) { ticket.min_price == ticket.max_price ? "$#{ticket.max_price}" : "$#{ticket.min_price} ~ $#{ticket.max_price}" }
      index = 0
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
        event.channel.send_message(message)
        # event.channel.send_file(ticket.event_image_url) if ticket.event_image_url
        event.channel.send_message('=' * 55)

        index += 1
        sleep(1)
      end
    end

    bot.message do |event|
      self.handle_message(event)
    end

    bot.send_message(CHANNEL_ID, 'Started bot!')

    bot.run
  end

  def self.handle_message(event)
    user_message = event.message.content
    p user_message.downcase
    if user_message.downcase == 'hello'
      event.respond 'Hello there, what do you want?'
    end
  end

  def self.send_message(content)
    bot = Discordrb::Bot.new token: BOT_TOKEN
    channel = bot.channel(CHANNEL_ID.to_i)
    channel.send_message(content)
  end
end
