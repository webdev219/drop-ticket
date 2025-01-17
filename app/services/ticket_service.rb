class TicketService
  API_KEY = Rails.application.credentials.config[:ticket][:key]
  SECRET = Rails.application.credentials.config[:ticket][:secret]

  def self.get_events(params)
    size    = 10
    source  = 'ticketmaster'
    query_params = params.map{|k,v| "#{k}=#{v}"}.join("&")
    url="https://app.ticketmaster.com/discovery/v2/events.json?#{query_params}&size=#{size}&apikey=#{API_KEY}&sort=date,asc&onsaleOnStartDate=#{Date.today.strftime("%Y-%m-%d")}"
    p '===============', params, url
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
