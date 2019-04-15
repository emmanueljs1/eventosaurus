class Event < ApplicationRecord
  validates_presence_of :title, :description, :location, :date
  validates_uniqueness_of :title
  has_many :events_users, dependent: :destroy
  has_many :attendees, through: :events_users, source: :user
end
