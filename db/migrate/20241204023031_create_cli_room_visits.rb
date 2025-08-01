class CreateCliRoomVisits < ActiveRecord::Migration[8.0]
  def change
    create_table :cli_room_visits do |t|
      t.references :cli_soork_player, null: false, foreign_key: true
      t.references :cli_room, null: false, foreign_key: true
      t.integer :visit_count
      t.datetime :last_visited_at

      t.timestamps
    end
  end
end
