class AddUniqueIndexToTicketEventOnPrimaryEventUrl < ActiveRecord::Migration[8.0]
  def change
    add_index :ticket_events, :primary_event_url, unique: true
  end
end
