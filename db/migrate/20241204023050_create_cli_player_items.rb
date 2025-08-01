class CreateCliPlayerItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cli_player_items do |t|
      t.references :cli_soork_player, null: false, foreign_key: true
      t.references :cli_item, null: false, foreign_key: true
      t.integer :uses_remaining
      t.integer :current_durability
      t.boolean :equipped
      t.datetime :acquired_at

      t.timestamps
    end
  end
end
