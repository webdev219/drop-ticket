require 'discordrb'

class TicketService
  KEY = Rails.application.credentials.config[:ticket][:key]
  SECRET = Rails.application.credentials.config[:ticket][:secret]

  def self.get_events(key = 'restaurant', page = 1, size = 50, source = 'ticketmaster')
    url="https://app.ticketmaster.com/discovery/v2/events.json?keyword=#{key}&size=#{size}&apikey=#{KEY}"
    response = Faraday.get(url)
    response = JSON.parse(response.body)
    response['_embedded']['events'].map do |event|
      <<~EVENT_MESSAGE
        #{event['name']}
        #{event['url']}
        #{event['dates']['start']['localDate'].to_date.strftime("%a • %b %m, %y")} #{event['dates']['start']['localTime'].to_time.strftime("• %-I:%M %p") rescue nil}
      EVENT_MESSAGE
    end
  end
end
