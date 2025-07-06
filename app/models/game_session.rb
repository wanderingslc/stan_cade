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

  def get_item(item)
    game_session_items.where("LOWER(name) ILIKE LOWER(?)", item).first
  end

  def use_item(item)
    if has_item?(item)
      game_session_item = game_session_items.find_by(item: item)
      return false if game_session_item.nil?
      return false if game_session_item.uses_remaining.to_i <= 0
      game_session_item.update(uses_remaining: game_session_item.uses_remaining - 1)
    else
      false
    end
  end

  private
end
