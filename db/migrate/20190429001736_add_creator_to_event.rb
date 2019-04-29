class AddCreatorToEvent < ActiveRecord::Migration[5.1]
  def change
    add_reference :events, :creator
  end
end
