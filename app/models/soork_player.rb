class SoorkPlayer < ApplicationRecord
  include AASM

  belongs_to :soork
  belongs_to :user, optional: true
  belongs_to :current_room, class_name: 'Room'
  has_many :room_visits
  has_many :visited_rooms, through: :room_visits, source: :room
  has_many :player_items, dependent: :destroy
  has_many :items, through: :player_items


  # validates :game_state_flags, presence: true
  # after_initialize :initialize_game_state_flags
  validate :user_required_if_login_required

  aasm column: 'state' do
    state :active, initial: true
    state :dead
    state :won
    state :paused

    event :die do
      transitions from: [:active, :paused], to: :dead
    end

    event :win do
      transitions from: [:active, :paused], to: :won
    end

    event :pause do
      transitions from: :active, to: :paused
    end

    event :resume do
      transitions from: :paused, to: :active
    end
  end

  before_save :update_last_played

  def find_item_by_name(name)
    items.find_by("lower(name) = ?", name)
  end

  def visit_room(room)
    visit = room_visits.find_or_initialize_by(room: room)
    visit.visit_count = visit.visit_count.to_i + 1
    visit.last_visited_at = Time.current
    visit.save
    update(current_room: room)
  end

  def times_visited(room)
    room_visits.find_by(room: room)&.visit_count || 0
  end

  def use_item(item)
    player_item = player_items.find_by(item: item)
    return false if player_item.nil?
    return false if player_item.uses_remaining.to_i <= 0
    player_item.update(uses_remaining: player_item.uses_remaining - 1)
  end

  def pick_up_item(item)
    return false unless item.can_be_picked_up?
    return false if has_item?(item)
    player_items.create(
      item: item,
      uses_remaining: item.default_uses,
      current_durability: item.default_durability,
      acquired_at: Time.current
    )
  end

  def drop_item(item)
    player_items.find_by(item: item)&.destroy
  end

  def has_item?(item)
    player_items.exists?(item: item)
  end

  def set_flag(key, value)
    self.game_state_flags = game_state_flags.merge(key.to_s => value)
    save
  end

  def get_flag(key)
    game_state_flags[key.to_s]
  end


  private

  def initialize_game_state_flags
    self.game_state_flags ||= {}
  end

  def user_required_if_login_required
    if requires_login? && user_id.nil?
      errors.add(:user, 'Logging in is required for this Soork')
    end
  end

  def update_last_played
    self.last_played_at = Time.zone.now
  end
end
