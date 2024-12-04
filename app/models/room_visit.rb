class RoomVisit < ApplicationRecord
  belongs_to :soork_player
  belongs_to :room

  validates :visit_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :last_visited_at, presence: true
end
