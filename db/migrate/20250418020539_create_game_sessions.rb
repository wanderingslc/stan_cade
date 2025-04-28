class CreateGameSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :game_sessions do |t|
      t.references :user, foreign_key: true
      t.references :soork, null: false, foreign_key: true
      t.references :current_room, null: false, foreign_key: {to_table: 'rooms'}
      t.jsonb :game_state_flags, default: {}
      t.jsonb :items, default: {}
    
      t.timestamps
    end
  end
end
