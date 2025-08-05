module Web
  class Item < ApplicationRecord
    self.table_name = 'web_items'

    belongs_to :soork, class_name: 'Web::Soork'
    belongs_to :area, class_name: 'Web::Area', optional: true
    
    has_many :game_session_items, dependent: :destroy
    has_many :game_sessions, through: :game_session_items
    has_many :area_connections, foreign_key: :required_item_id
    has_many :interactions, foreign_key: :required_item_id

    validates :name, presence: true
    validates :description, presence: true
    validates :default_uses, presence: true, numericality: { greater_than: 0 }
    validates :default_durability, presence: true, numericality: { greater_than: 0 }

    scope :pickable, -> { where(is_pickable: true) }
    scope :in_areas, -> { where.not(area_id: nil) }
    scope :unassigned, -> { where(area: nil) }

    def can_be_picked_up?
      is_pickable
    end

    def unlocks?(area_connection)
      area_connection.required_item_id == self.id
    end
  end
end