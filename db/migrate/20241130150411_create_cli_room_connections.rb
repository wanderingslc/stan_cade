class CreateCliRoomConnections < ActiveRecord::Migration[8.0]
  def change
    create_table :cli_room_connections do |t|
      t.references :source_room, null: false, foreign_key: {to_table: :cli_rooms}
      t.references :target_room, null: false, foreign_key: {to_table: :cli_rooms}
      t.string :direction, null: false

      t.timestamps

    end
    add_index :cli_room_connections, [:source_room_id, :direction], unique: true
  end
end
