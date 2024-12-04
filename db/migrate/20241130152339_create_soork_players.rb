class CreateSoorkPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :soork_players do |t|
      t.references :soork, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.references :current_room, null: false, foreign_key: { to_table: :rooms }
      t.jsonb :game_state_flags, default: {}, null: false
      t.string :state, null: false, default: 'active'
      t.boolean :requires_login, default: false
      t.datetime :last_played_at

      t.timestamps
    end

    add_index :soork_players, :state
    add_index :soork_players, :game_state_flags, using: :gin
  end
end