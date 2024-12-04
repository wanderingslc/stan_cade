class Item < ApplicationRecord
  include AASM

  belongs_to :room
  has_one :soork, through: :room

  validates :name, presence: true
  validates :description, presence: true
  validates :properties, exclusion: { in: [nil] }

  scope :pickable, -> {where(is_pickable: true)}
  scope :by_name, -> {order(:name)}

  aasm column: 'state' do
    state :inactive, initial: true
    state :active
    state :used
    state :broken

    event :activate do
      transitions from: :inactive, to: :active
    end

    event :use do
      transitions from: :active, to: :used
    end

    event :break do
      transitions from: [:active, :used], to: :broken
    end

    event :reset do
      transitions from: [:used, :broken], to: :inactive
    end
  end

  def default_uses
    properties['uses'] || nil
  end

  def default_durability
    properties['durability'] || nil
  end

  def examine
    examine_text.presence || description
  end

  def get_property(key)
    properties[key.to_s]
  end

  def set_property(key, value)
    self.properties = properties.merge(key.to_s => value)
  end

  def has_property?(key)
    properties.key?(key.to_s)
  end

  def can_be_picked_up?
    is_pickable?
  end
end
