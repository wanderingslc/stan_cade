module Web
  class GameSessionItem < ApplicationRecord
    self.table_name = 'web_game_session_items'
    belongs_to :game_session
    belongs_to :item
    validates :uses_remaining,
              numericality: { greater_than_or_equal_to: 0 },
              allow_nil: true
    validates :current_durability,
              numericality: { greater_than_or_equal_to: 0 },
              allow_nil: true
  end
end

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
