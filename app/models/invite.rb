class Invite < ApplicationRecord
  belongs_to :inviter, class_name: 'User'
  belongs_to :invitee, class_name: 'User'
  belongs_to :event
  validate :user_cannot_invite_self

  def user_cannot_invite_self
    errors.add(:inviter, 'cannot invite itself') if inviter == invitee
  end
end
