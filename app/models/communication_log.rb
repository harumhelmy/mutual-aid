class CommunicationLog < ApplicationRecord
  belongs_to :person, optional: true
  belongs_to :match, optional: true

  def name
    "#{created_at}: #{channel}"
  end
end
