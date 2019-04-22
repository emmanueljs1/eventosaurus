class AddInviterToInvites < ActiveRecord::Migration[5.1]
  def change
    add_reference :invites, :inviter
  end
end
