class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.text :examine_text
      t.references :room, null: false, foreign_key: true
      t.boolean :is_pickable, default: true
      t.string :state, null: false, default: 'inactive'
      t.json :properties, default: {}, null: false

      t.timestamps
    end
    add_index :items, :name
    add_index :items, :state
  end
end
