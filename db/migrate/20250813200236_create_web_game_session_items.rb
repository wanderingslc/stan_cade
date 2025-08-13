class CreateWebGameSessionItems < ActiveRecord::Migration[8.0]
  def change
    create_table :web_game_session_items do |t|
      t.references :game_session, null: false, foreign_key: {to_table: :web_game_sessions}
      t.references :item, null: false, foreign_key: {to_table: :web_items}
      t.integer :uses_remaining
      t.integer :current_durability
      t.boolean :equipped
      t.datetime :acquired_at

      t.timestamps
    end
    add_index :web_game_session_items, [:game_session_id, :item_id], unique: true, name: 'index_game_session_items_on_game_session_id_and_item_id'
  end
end
