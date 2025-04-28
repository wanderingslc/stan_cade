# == Schema Information
#
# Table name: game_session_items
#
#  id                 :integer          not null, primary key
#  game_session_id    :integer          not null
#  item_id            :integer          not null
#  uses_remaining     :integer
#  current_durability :integer
#  equipped           :boolean
#  acquired_at        :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class GameSessionItem < ApplicationRecord
end
