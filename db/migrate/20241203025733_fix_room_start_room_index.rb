class FixRoomStartRoomIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :rooms, [:soork_id, :start_room]
    add_index :rooms, [:soork_id, :start_room], unique: true, where: 'start_room = true'
  end
end
