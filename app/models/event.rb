class Event < ActiveRecord::Base
  has_many :users
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :event_categories
  has_many :categories, through: :event_categories
  accepts_nested_attributes_for :categories
  validates :short_description, presence: true, length: {maximum: 140}
  validates :date, presence: true
  validates :time, presence: true
  validates :additional_info, length: {maximum: 280}

  def self.upcoming_events(num = nil)
    if num
      where("created_at >=?", Time.zone.today.beginning_of_day).order(date: :desc).limit(num)
    else
      where("created_at >=?", Time.zone.today.beginning_of_day).order(date: :desc)
    end
  end

  def self.previous_events
    where("created_at <?", Time.zone.today.beginning_of_day)
  end

  def self.next_upcoming_event
    self.upcoming_events.limit(1)
  end
end
