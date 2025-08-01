class CreateCliRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :cli_rooms do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.text :first_visit_text
      t.references :soork, null: false, foreign_key: {to_table: :cli_soorks}
      t.integer :x, null: false, default: 0
      t.integer :y, null: false, default: 0
      t.string :state, null: false, default: 'locked'
      t.boolean :start_room, default: false

      t.timestamps
    end

    add_index :cli_rooms, [:soork_id, :start_room], unique: true, where: "start_room = true"
    add_index :cli_rooms, :state
  end
end
