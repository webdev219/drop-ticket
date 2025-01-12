class StaticPagesController < ApplicationController
  def home
  end

  def about
    DiscordBotService.send_message('Visit about page')
  end

  def contact
    DiscordBotService.send_message('Visit contact page')
  end

  def help
    DiscordBotService.send_message('Visit help page')
  end
end
