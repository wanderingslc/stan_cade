# == Schema Information
#
# Table name: room_visits
#
#  id              :integer          not null, primary key
#  soork_player_id :integer          not null
#  room_id         :integer          not null
#  visit_count     :integer
#  last_visited_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class RoomVisit < ApplicationRecord
  belongs_to :soork_player
  belongs_to :room

  validates :visit_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :last_visited_at, presence: true
end
