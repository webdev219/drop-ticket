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
      bot.send_message(event.channel.id, 'I am ready to getting all tickets.')
    end

    bot.command(:events, help_available: true) do |event|
      bot.send_message(event.channel.id, 'I am obtaining the event data from Ticketmaster through their API!!!')
      events = TicketService.get_events
      index = 0
      loop do
        break if index > events.count - 1

        bot.send_message(event.channel.id, events[index])
        bot.send_message(event.channel.id, '=' * 55)

        index += 1
        sleep(1)
      end
    end

    bot.send_message(CHANNEL_ID, 'Started bot!')

    bot.run
  end

  def self.send_message(content)
    bot = Discordrb::Bot.new token: BOT_TOKEN
    channel = bot.channel(CHANNEL_ID.to_i)
    channel.send_message(content)
  end
end
