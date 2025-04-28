class CreateGameSessionItems < ActiveRecord::Migration[8.0]
  def change
    create_table :game_session_items do |t|
      t.references :game_session, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :uses_remaining
      t.integer :current_durability
      t.boolean :equipped
      t.datetime :acquired_at

      t.timestamps
    end
  end
end
