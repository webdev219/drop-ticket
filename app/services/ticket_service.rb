class TicketService
  API_KEY = Rails.application.credentials.config[:ticket][:key]
  SECRET  = Rails.application.credentials.config[:ticket][:secret]

  def self.get_events(params)
    p params
    tickets = TicketEvent.where(venue_country_code: params[:country_code])
    tickets = tickets.where("LOWER(classification_genre) LIKE :key OR LOWER(classification_sub_genre) LIKE :key", key: "%#{params[:keyword].downcase}%").limit(10)
    tickets
  end
end
