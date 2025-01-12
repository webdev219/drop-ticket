require 'discordrb'

class TicketService
  KEY = Rails.application.credentials.config[:ticket][:key]
  SECRET = Rails.application.credentials.config[:ticket][:secret]

  def self.run
    
  end

  def self.send_message(content)
    
  end
end
