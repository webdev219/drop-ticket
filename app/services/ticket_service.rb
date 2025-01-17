class TicketService
  API_KEY = Rails.application.credentials.config[:ticket][:key]
  SECRET = Rails.application.credentials.config[:ticket][:secret]

  def self.get_events(key = 'restaurant', size = 50, source = 'ticketmaster')
    p '==================key', key
    # https://app.ticketmaster.com/discovery/v2/events.json?keyword=music&size=50&apikey=NsIAG0GaqplfJIxlS6y1OM73AAFUscqG&sort=date,asc&onsaleOnStartDate=2025-01-20

    url="https://app.ticketmaster.com/discovery/v2/events.json?keyword=#{key}&size=#{size}&apikey=#{API_KEY}&sort=date,asc&onsaleOnStartDate=#{Date.today.strftime("%Y-%m-%d")}"
    response = Faraday.get(url)
    response = JSON.parse(response.body)

    return [] unless response['_embedded']

    response['_embedded']['events'].map do |event|
      <<~EVENT_MESSAGE
        #{event['name']}
        #{event['url']}
        #{event['dates']['start']['localDate'].to_date.strftime("%a • %b %m, %y")} #{event['dates']['start']['localTime'].to_time.strftime("• %-I:%M %p") rescue nil}
      EVENT_MESSAGE
    end
  end
end
