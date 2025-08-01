class CreateCliSoorkPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :cli_soork_players do |t|
      t.references :cli_soork, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.references :current_room, null: false, foreign_key: { to_table: :cli_rooms }
      t.jsonb :game_state_flags, default: {}, null: false
      t.string :state, null: false, default: 'active'
      t.boolean :requires_login, default: false
      t.datetime :last_played_at

      t.timestamps
    end

    add_index :cli_soork_players, :state
    add_index :cli_soork_players, :game_state_flags, using: :gin
  end
end