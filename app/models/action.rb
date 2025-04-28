# == Schema Information
#
# Table name: actions
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Action < ApplicationRecord
  def examine_item(item)
    puts "Name: #{item.name}"
    puts item.examine
    puts "Properties: #{item.properties}"
  end
end
