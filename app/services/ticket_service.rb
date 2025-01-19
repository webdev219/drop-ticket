class TicketService
  API_KEY = Rails.application.credentials.config[:ticket][:key]
  SECRET = Rails.application.credentials.config[:ticket][:secret]

  def self.get_events(params)
    p params
    tickets = TicketEvent.where(venue_country_code: params[:country_code])
    tickets = tickets.where("LOWER(classification_genre) LIKE :key OR LOWER(classification_sub_genre) LIKE :key", key: "%#{params[:keyword].downcase}%")

    tickets.map do |ticket|
      <<~EVENT_MESSAGE
        #{ticket.event_name}
        #{ticket.primary_event_url}
        #{ticket.event_start_local_date.strftime("%a • %b %m, %y")} #{ticket.event_start_local_time.strftime("• %-I:%M %p") rescue nil}
        #{ticket.event_image_url}
      EVENT_MESSAGE
    end
  end
end
