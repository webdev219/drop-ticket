require 'discordrb'

class DiscordBotService
  BOT_TOKEN = Rails.application.credentials.config[:discord][:token]
  CLIENT_ID = Rails.application.credentials.config[:discord][:client_id]
  CHANNEL_ID = 1328014476993368213
  def self.run
    bot = Discordrb::Bot.new token: BOT_TOKEN, client_id: CLIENT_ID

    bot.ready do
      puts 'Bot is online and ready!'
    end

    bot.message(with_text: '!ping') do |event|
      event.respond 'Pong!'
    end

    bot.run
  end

  def self.send_message(content)
    bot = Discordrb::Bot.new token: BOT_TOKEN
    channel = bot.channel(CHANNEL_ID.to_i)
    channel.send_message(content)
  end
end
