class CreateSoorks < ActiveRecord::Migration[8.0]
  def change
    create_table :soorks do |t|
      t.string :title, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.string :state, null: false, default:  'draft'
      t.boolean :published, default: false
      t.datetime :published_at

      t.timestamps
    end
    add_index :soorks, :state
  end
end
