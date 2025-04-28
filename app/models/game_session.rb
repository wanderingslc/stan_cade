class GameSession < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :soork
  belongs_to :current_room, class_name: 'Room', optional: true
  has_many :game_session_items
  has_many :items, through: :game_session_items


  def pick_up_item(item)
    return false unless item.can_be_picked_up?
    return false if has_item?(item)

  end
end
