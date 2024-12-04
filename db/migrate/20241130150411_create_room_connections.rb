class CreateRoomConnections < ActiveRecord::Migration[8.0]
  def change
    create_table :room_connections do |t|
      t.references :source_room, null: false, foreign_key: {to_table: :rooms}
      t.references :target_room, null: false, foreign_key: {to_table: :rooms}
      t.string :direction, null: false

      t.timestamps

    end
    add_index :room_connections, [:source_room_id, :direction], unique: true
  end
end
