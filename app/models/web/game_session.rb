module Web
  class GameSession < ApplicationRecord
    self.table_name = 'web_game_sessions'
    
    belongs_to :user, optional: true
    belongs_to :soork, class_name: 'Web::Soork'
    belongs_to :current_area, class_name: 'Web::Area', optional: true

    has_many :game_session_items, dependent: :destroy
    has_many :items, through: :game_session_items

    validates :soork, presence: true
    validates :current_area, presence: true
    validate :current_area_belongs_to_soork

    scope :active, -> {where(created_at: 1.day.ago..Time.current)}
    scope :by_user, ->(user) {where(user: user)}

    def state_new_game!
      start_area = soork.start_area
      raise "No start area defined for Soork" unless start_area

      update!(current_area: start_area, game_state_flags: {})
    end

    def move_to_area(direction)
      connection = current_area.send("#{direction}_connection")
      return false unless connection
      
      update!(current_area: connection.target_area)
      true 
    end

    def available_exits
      current_area.exits
    end

    def current_area_description
      current_area.describe_area if current_area
    end


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

    def current_area_belongs_to_soork
      return unless current_area && soork

      unless current_area.soork_id == soork.id
        errors.add(:current_area, "must belong to the same Soork as the game session")
      end
    end
  end
end
