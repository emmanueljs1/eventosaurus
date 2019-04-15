class EventsUser < ApplicationRecord
  validates :user, uniqueness: { scope: :event }
  belongs_to :event
  belongs_to :user
end
