class CreateWebAreas < ActiveRecord::Migration[8.0]
  def change
    create_table :web_areas do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.text :first_visit_text
      t.references :soork, null: false, foreign_key: {to_table: :web_soorks}
      t.boolean :start_area, default: false

      t.timestamps
    end

    add_index :web_areas, [:soork_id, :start_area], unique: true, where: "start_area = true"
  end
end
