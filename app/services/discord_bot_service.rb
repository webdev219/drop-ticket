require 'discordrb'

class DiscordBotService
  BOT_TOKEN = Rails.application.credentials.config[:discord][:token]
  CLIENT_ID = Rails.application.credentials.config[:discord][:client_id]
  CHANNEL_ID = 1328014476993368213
  USER_ID=1312259562384003092

  def self.run
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
      DiscordBotComponentService.add_keyword
    end

    bot.button(custom_id: 'keyword') do |event|
      event.respond(content: 'You selected keyword, please input keyword "music or restaurant".')
      bot.add_await!(Discordrb::Events::MessageEvent, timeout: 60) do |response_event|
        keyword = response_event.message.content.strip
        
        event.channel.send_message("You entered the keyword: #{keyword}")
        events = TicketService.get_events(keyword)
        index = 0
        loop do
          break if index > events.count - 1

          event.channel.send_message(events[index])
          event.channel.send_message('=' * 55)

          index += 1
          sleep(1)
        end
        true # Stop listening after handling the response
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
      event.respond 'Hello there!'
    end
  end

  def self.send_message(content)
    bot = Discordrb::Bot.new token: BOT_TOKEN
    channel = bot.channel(CHANNEL_ID.to_i)
    channel.send_message(content)
  end
end
