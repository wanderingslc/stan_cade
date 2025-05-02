class GameSession < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :soork
  belongs_to :current_room, class_name: 'Room', optional: true
  has_many :game_session_items
  has_many :items, through: :game_session_items


  def pick_up_item(item)
    return false unless item.can_be_picked_up?
    return false if has_item?(item)
    game_session_items.create(
      item: item,
      uses_remaining: item.default_uses,
      current_durability: item.default_durability,
      acquired_at: Time.current,
    )
    
    {
      item: item
    }
  end

  def has_item?(item)
    game_session_items.exists?(item: item)
  end

  private
end
