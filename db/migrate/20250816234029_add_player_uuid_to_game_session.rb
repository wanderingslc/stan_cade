class AddPlayerUuidToGameSession < ActiveRecord::Migration[8.0]
  def change
    add_column :web_game_sessions, :player_uuid, :string
    add_index :web_game_sessions, :player_uuid
  end
end
