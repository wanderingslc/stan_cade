class CreateRoomVisits < ActiveRecord::Migration[8.0]
  def change
    create_table :room_visits do |t|
      t.references :soork_player, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.integer :visit_count
      t.datetime :last_visited_at

      t.timestamps
    end
  end
end
