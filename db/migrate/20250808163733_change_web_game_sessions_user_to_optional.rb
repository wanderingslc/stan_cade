class ChangeWebGameSessionsUserToOptional < ActiveRecord::Migration[8.0]
  def change
    change_column_null :web_game_sessions, :user_id, true
  end
end
