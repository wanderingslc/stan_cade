class Room < ApplicationRecord
  include AASM

  belongs_to :soork
  has_many :items, dependent: :destroy

  has_one :north_connection, -> { where(direction: 'north') },
          class_name: 'RoomConnection',
          foreign_key: 'source_room_id'

  has_one :south_connection, -> { where(direction: 'south') },
          class_name: 'RoomConnection',
          foreign_key: 'source_room_id'

  has_one :east_connection, -> { where(direction: 'east') },
          class_name: 'RoomConnection',
          foreign_key: 'source_room_id'

  has_one :west_connection, -> { where(direction: 'west') },
          class_name: 'RoomConnection',
          foreign_key: 'source_room_id'

  has_one :north_room, through: :north_connection, source: :target_room
  has_one :south_room, through: :south_connection, source: :target_room
  has_one :east_room, through: :east_connection, source: :target_room
  has_one :west_room, through: :west_connection, source: :target_room

  has_many :connected_rooms, through: :room_connections, source: :target_room

  validates :name, presence: true
  validates :description, presence: true
  validates :x, :y, presence: true, numericality: true
  validate :only_one_start_room_per_soork

  scope :start_rooms, -> {where(start_room: true)}
  scope :by_position, -> {order(:y, :x)}

  aasm column: 'state' do
    state :locked, initial: true
    state :unlocked
    state :hidden
    state :visible

    event :unlock do
      transitions from: :locked, to: :unlocked
      transitions from: :hidden, to: :visible
    end

    event :hide do
      transitions from: [:unlocked, :visible], to: :hidden
    end

    event :reveal do
      transitions from: :hidden, to: :visible
    end
  end

  def connected_room_in_direction(direction)
    send("#{direction}_connections").first&.target_room
  end

  def available_directions
    %w[north south east west].select do |direction|
      send("#{direction}_connections").exists?
    end
  end

  def description_for_visit(first_visit = false)
    return first_visit_text if first_visit && first_visit_text.present?
    description
  end

  def by_name(name)
    items.where("lower(name) = ?", name.downcase).first
  end

  def use_item(item)
    item.use
  end

  def use_items(item1, item2)

  end
  def remove_item(item)
    items.delete(item)
  end

  private

  def only_one_start_room_per_soork
    return unless start_room?

    existing_start = soork.rooms.start_rooms.where.not(id: id).exists?
    if existing_start
      errors.add(:start_room, 'Already exists for this Soork')
    end
  end
end
