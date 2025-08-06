class CreateWebGameSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :web_game_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :soork, null: false, foreign_key: {to_table: :web_soorks}
      t.references :current_area, null: false, foreign_key: {to_table: :web_areas}
      t.jsonb :game_state_flags

      t.timestamps
    end

  end
end
