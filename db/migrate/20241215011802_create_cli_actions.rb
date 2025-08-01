class CreateCliActions < ActiveRecord::Migration[8.0]
  def change
    create_table :cli_actions do |t|
      t.timestamps
    end
  end
end
