module Web
  class Interaction < ApplicationRecord
    self.table_name = 'web_interactions'

    belongs_to :area, class_name: 'Web::Area'
    belongs_to :item, class_name: 'Web::Item'

    validates :success_message, presence: true

    def execute(game_session)
      apply_effects(game_session) if effects.present?

      {
        message: success_message,
        effects: effects
      }
    end

    private

    def apply_effects(game_session)
        return unless effects.is_a?(Hash)
  
      if effects['illuminate']
        # Mark this area as illuminated for this game session
        game_session.game_state_flags ||= {}
        game_session.game_state_flags['illuminated_areas'] ||= []
        unless game_session.game_state_flags['illuminated_areas'].include?(area.id)
          game_session.game_state_flags['illuminated_areas'] << area.id
        end
        game_session.save!
      end

      if effects['reveals_items'] && effects['reveals_items'].is_a?(Array)
        effects['reveals_items'].each do |item_name|
          # Find the item by name in this soork and move it to this area
          item = area.soork.items.find_by("LOWER(name) = LOWER(?)", item_name)
          if item
            item.update!(area: area)
          end
        end
      end
    end
  end
end
