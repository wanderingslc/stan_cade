class CreateWebSoorks < ActiveRecord::Migration[8.0]
  def change
    create_table :web_soorks do |t|
      t.string :title
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.string :state
      t.boolean :published
      t.datetime :published_at

      t.timestamps
    end

    add_index :web_soorks, :state
    add_index :web_soorks, :published
  end
end
