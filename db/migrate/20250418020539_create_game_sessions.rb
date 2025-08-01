class CreateWebGameSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :web_game_sessions do |t|
      t.references :user, foreign_key: true
      t.references :web_soork, null: false, foreign_key: true
      t.references :web_current_area, null: false, foreign_key: {to_table: 'web_areas'}
      t.jsonb :items, default: {}
    
      t.timestamps
    end
  end
end
