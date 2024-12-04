# app/models/room_connection.rb
class RoomConnection < ApplicationRecord
  belongs_to :source_room, class_name: 'Room'
  belongs_to :target_room, class_name: 'Room'

  validates :direction, presence: true,
            inclusion: { in: %w(north south east west) }
  validate :rooms_belong_to_same_game
  validate :no_duplicate_connections

  private

  def rooms_belong_to_same_game
    return unless source_room && target_room
    unless source_room.soork_id == target_room.soork_id
      errors.add(:base, "Rooms must belong to the same game")
    end
  end

  def no_duplicate_connections
    return unless source_room && direction
    if RoomConnection.exists?(source_room: source_room, direction: direction)
      errors.add(:base, "Room already has a connection in that direction")
    end
  end
end