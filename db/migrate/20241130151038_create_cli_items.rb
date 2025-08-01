class CreateCliItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cli_items do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.text :examine_text
      t.references :room, null: false, foreign_key: {to_table: :cli_rooms}
      t.boolean :is_pickable, default: true
      t.boolean :picked_up, default: false
      t.string :state, null: false, default: 'inactive'
      t.json :properties, default: {}, null: false

      t.timestamps
    end
    add_index :cli_items, :name
    add_index :cli_items, :state
  end
end
