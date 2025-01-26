class TicketService
  API_KEY = Rails.application.credentials.config[:ticket][:key]
  SECRET  = Rails.application.credentials.config[:ticket][:secret]

  def self.get_events(params)
    tickets    = TicketEvent.where(venue_country_code: params['country_code'])
    tickets    = tickets.where("created_at > ?", params[:sent_at]) if params[:sent_at]
    keywords   = params['keyword'].map(&:downcase)
    conditions = keywords.map { |key| "LOWER(classification_genre) LIKE ? OR LOWER(classification_sub_genre) LIKE ?" }.join(" OR ")
    values     = keywords.flat_map { |key| ["%#{key}%", "%#{key}%"] }

    tickets = tickets.where(conditions, *values).limit(10)
    tickets
  end

  def self.get_tickets(params)
  end
end
