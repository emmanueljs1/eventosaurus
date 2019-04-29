class Event < ApplicationRecord
  validates_presence_of :title, :description, :location, :date
  validates_uniqueness_of :title
  belongs_to :creator, class_name: 'User'
  has_many :events_users, dependent: :destroy
  has_many :attendees, through: :events_users, source: :user
  has_many :invites, dependent: :destroy

  def invitees
    invites.map(&:invitee)
  end

  def invite_user(inviter, invitee)
    return false if Invite.exists?(invitee: invitee, event: self) || attendees.include?(invitee)

    invite = Invite.new(inviter: inviter, invitee: invitee, event: self)
    inviter.invites_sent << invite
    invitee.invites_received << invite
    invite.save
  end
end
