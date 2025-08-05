class CreateWebItems < ActiveRecord::Migration[8.0]
  def change
    create_table :web_items do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.text :examine_text
      t.references :area, null: false, foreign_key: {to_table: :web_areas}
      t.references :soork, null: false, foreign_key: {to_table: :web_soorks}
      t.boolean :is_pickable, default: true
      t.integer :default_uses, default: 100
      t.integer :default_durability, default: 100
      t.jsonb :properties, default: {}

      t.timestamps
    end

    add_index :web_items, :name
    add_index :web_items, :is_pickable
  end
end
