class RemoveUserFromInvites < ActiveRecord::Migration[5.1]
  def change
    remove_reference :invites, :user, foreign_key: true
  end
end
