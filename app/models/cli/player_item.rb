module Cli
  # == Schema Information
#
# Table name: player_items
#
#  id                 :integer          not null, primary key
#  soork_player_id    :integer          not null
#  item_id            :integer          not null
#  uses_remaining     :integer
#  current_durability :integer
#  equipped           :boolean
#  acquired_at        :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

  class PlayerItem < ApplicationRecord
    self.table_name = 'cli_player_items'
    belongs_to :soork_player
    belongs_to :item

    validates :uses_remaining,
              numericality: { greater_than_or_equal_to: 0 },
              allow_nil: true
    validates :current_durability,
              numericality: { greater_than_or_equal_to: 0 },
              allow_nil: true
  end
end
