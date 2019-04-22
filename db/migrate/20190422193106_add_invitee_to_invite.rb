class AddInviteeToInvite < ActiveRecord::Migration[5.1]
  def change
    add_reference :invites, :invitee
  end
end
