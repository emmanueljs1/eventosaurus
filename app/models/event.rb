class Event < ApplicationRecord
  validates_presence_of :title, :description, :location, :date
  validates_uniqueness_of :title
  has_many :events_users, dependent: :destroy
  has_many :attendees, through: :events_users, source: :user
  has_many :invites, dependent: :destroy

  def creator
    attendees[0]
  end

  def invite_user(user)
    return false if Invite.exists?(user: user, event: self)
    invite = Invite.new(user: user, event: self)
    invite.save
  end
end
