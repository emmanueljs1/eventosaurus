class Event < ApplicationRecord
  validates_presence_of :title, :description, :location, :date
  validates_uniqueness_of :title
  validates :description, length: { minimum: 5 }
  has_many :events_users, dependent: :destroy
  has_many :users, through: :events_users
end
