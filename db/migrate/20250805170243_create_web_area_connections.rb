class CreateWebAreaConnections < ActiveRecord::Migration[8.0]
  def change
    create_table :web_area_connections do |t|
      t.references :source_area, null: false, foreign_key: {to_table: :web_areas}
      t.references :target_area, null: false, foreign_key: {to_table: :web_areas}
      t.string :direction, null: false
      # Will be added later when items are implemented
      # t.references :required_item, null: false, foreign_key: {to_table: :web_items}

      t.timestamps
    end

    add_index :web_area_connections, [:source_area_id, :target_area_id], unique: true
    add_index :web_area_connections, :direction
  end
end

