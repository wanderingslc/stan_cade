class CreateWebInteractions < ActiveRecord::Migration[8.0]
  def change
    create_table :web_interactions do |t|
      t.references :area, null: false, foreign_key: {to_table: :web_areas}
      t.references :item, null: false, foreign_key: {to_table: :web_items}
      t.string :target_name
      t.text :success_message
      t.json :effects
      t.boolean :consumes_item, default: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
