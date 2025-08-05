class AddRequiredItemToWebAreaConnections < ActiveRecord::Migration[8.0]
  def change
    add_reference :web_area_connections, :required_item, null: true, foreign_key: {to_table: :web_items}
  end
end
