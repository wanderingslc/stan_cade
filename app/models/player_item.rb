class PlayerItem < ApplicationRecord
  belongs_to :soork_player
  belongs_to :item

  validates :uses_remaining,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true
  validates :current_durability,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true
end
