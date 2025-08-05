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
    validates :start_area, uniqueness: {scope: :soork_id, message: "can only have one start area per soork"}

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

  end
end
