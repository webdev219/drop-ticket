class UserOption < ApplicationRecord
  validates :discord_id, presence: true

  def event_params
    options[:sent_at] = sent_at
    options
  end
end
