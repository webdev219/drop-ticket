class DiscordBotJob < ApplicationJob
  queue_as :default

  def perform(*args)
    DiscordBotService.run
  end
end
