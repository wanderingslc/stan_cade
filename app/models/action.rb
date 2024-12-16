class Action < ApplicationRecord
  def examine_item(item)
    puts "Name: #{item.name}"
    puts item.examine
    puts "Properties: #{item.properties}"
  end
end
