module Web
  class AreaConnection < ApplicationRecord
    self.table_name = 'web_area_connections'

    belongs_to :source_area, class_name: 'Web::Area'
    belongs_to :target_area, class_name: 'Web::Area'
    belongs_to :required_item, class_name: 'Web::Item', optional: true

    validates :direction, presence: true, inclusion: { in: %w[north south east west] }
    validate :area_belongs_to_same_soork
    validate :no_duplicate_connections

    def locked?
      required_item.present?
    end

    def accessible_to?(player_items)
      !locked? || player_items.include?(required_item)
    end
    

    private

    def area_belongs_to_same_soork
      return unless source_area && target_area

      unless source_area.soork_id == target_area.soork_id
        errors.add(:base, "Source and target areas must belong to the same Soork")
      end
    end

    def no_duplicate_connections
      return unless source_area && direction

      if Web::AreaConnection.exists?(source_area: source_area, direction: direction)
        errors.add(:base, "A connection in the #{direction} direction already exists for this area")
      end
    end
  end
end