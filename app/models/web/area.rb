module Web
  class Area < ApplicationRecord
    self.table_name = 'web_areas'

    belongs_to :soork, class_name: 'Web::Soork'
    has_many :items, dependent: :destroy

    has_one :north_connection, -> { where(direction: 'north') },
            class_name: 'AreaConnection',
            foreign_key: 'source_area_id'

    has_one :south_connection, -> { where(direction: 'south') },
            class_name: 'AreaConnection',
            foreign_key: 'source_area_id'
            
    has_one :east_connection, -> { where(direction: 'east') },
            class_name: 'AreaConnection',
            foreign_key: 'source_area_id'
            
    has_one :west_connection, -> { where(direction: 'west') },
            class_name: 'AreaConnection',
            foreign_key: 'source_area_id'
            
    has_one :north_area, through: :north_connection, source: :target_area
    has_one :south_area, through: :south_connection, source: :target_area
    has_one :east_area, through: :east_connection, source: :target_area
    has_one :west_area, through: :west_connection, source: :target_area        
            
    has_many :area_connections, foreign_key: :source_area_id, dependent: :destroy
    has_many :connected_areas, through: :area_connections, source: :target_area
    has_many :interactions, dependent: :destroy
    has_many :game_sessions, foreign_key: :current_area_id, dependent: :destroy

    validates :name, presence: true
    validates :description, presence: true
    validate :only_one_start_area_per_soork

    scope :start_areas, -> { where(start_area: true) }

    def exits
      {
        north: north_area,
        south: south_area,
        east: east_area,
        west: west_area
      }.compact
    end

    def describe_area
      {
        name: name,
        description: description,
        first_visit_text: first_visit_text,
        exits: exits,
        items: items.map(&:describe_item),
      }
    end

    def handle_item_use(item, target_name, game_session)
      if target_name
        handle_targeted_use(item, target_name, game_session)
      else
        handle_generic_use(item, game_session)
      end
    end

    private

    def only_one_start_area_per_soork
      return unless start_area?
      
      if soork.areas.where(start_area: true).exists?
        errors.add(:base, "Only one start area is allowed per Soork")
      end
    end

    def handle_targeted_use(item, target_name, game_session)
      interaction = Interaction.find_by(item: item, target_name: target_name)

      if interaction
        interaction.execute(game_session)
      else
        {
          type: 'error',
          message: "You can't use #{item.name} on #{target_name}.",
          game_session_id: game_session.id,
          current_area: {
            name: game_session.current_area.name,
            description: game_session.current_area.describe_area,
            exits: game_session.current_area.exits
          }
        }
      end
    end

    def handle_generic_use(item, game_session)
      interaction = Interaction.find_by(item: item, target_name: nil)

      if interaction
        interaction.execute(game_session)
      else
        {message: "You can't use #{item.name}."}
      end
    end
  end
end
