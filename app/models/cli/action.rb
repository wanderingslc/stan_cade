module Cli
  # == Schema Information
#
# Table name: actions
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

  class Action < ApplicationRecord
    self.table_name = 'cli_actions'
    
    def examine_item(item)
      puts "Name: #{item.name}"
      puts item.examine
      puts "Properties: #{item.properties}"
    end
  end
end
