class GameSession < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :soork
  belongs_to :current_room, class_name: 'Room', optional: true
  has_many :game_session_items, dependent: :destroy
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
    items.where("LOWER(name) ILIKE LOWER(?)", "%#{item}%").first
  end

  def use_item(item)
    debugger
    if has_item?(item)
   
      return false if item.nil?
      # return false if item.uses_remaining.to_i <= 0
      item.update(uses_remaining: game_session_item.uses_remaining - 1)
    else
      false
    end
  end

  def exit
    if user
      user.update(current_game_session_id: nil)
    end
    destroy
  end

  private
end
