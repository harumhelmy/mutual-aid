class Listing < ApplicationRecord
  extend Mobility

  acts_as_taggable_on :tags

  translates :title
  translates :description, type: :text

  belongs_to :person
  belongs_to :service_area
  belongs_to :location, optional: true
  belongs_to :submission, optional: true
  belongs_to :urgency_level, optional: true

  has_many :matches
  has_many :matches_as_receiver, class_name: "Match", foreign_key: "receiver_id"
  has_many :matches_as_provider, class_name: "Match", foreign_key: "provider_id"

  validates :type, presence: true

  enum state: { received: 0, fulfilled: 1 }

  scope :asks, ->(){ where(type: Ask.to_s) }
  scope :offers, ->(){ where(type: Offer.to_s) }

  def self.all_tags_unique(collection)
    collection ||= all
    collection.map(&:all_tags_unique).flatten.uniq
  end

  def communication_logs
    person.communication_logs.where(match: self)
  end

  def name
    type + ": #{all_tags_to_s} (#{person.name})"
  end

  def name_and_match_history
    "(#{type}-#{all_tags_to_s.upcase})</strong> #{person.match_history}. (#{person.name})"
  end

  def status
    status = "unmatched"
    if matches_as_receiver.any?
      status = matches_as_receiver.map{|m| m.completed?}.any? ? "completed" : "matched"
    elsif matches_as_provider.any?
      status = matches_as_provider.map{|m| m.completed?}.any? ? "completed" : "matched"
    end
    status
  end

  def ask?
    type == "Ask"
  end

  def offer?
    type == "Offer"
  end

  def icon_class
    if ask?
      "fa fa-hand-sparkles"
    elsif offer?
      "fa fa-hand-holding-heart"
    else
      "fa fa-question-circle"
    end
  end

  def all_tags_unique
    all_tags_list.flatten.map(&:downcase).uniq
  end

  def all_tags_to_s
    all_tags_unique.join(", ")
  end

  def categories_for_tags
    Category.where(name: tag_list)
  end
end
