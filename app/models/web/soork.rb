module Web
  class Soork < ApplicationRecord
    self.table_name = 'web_soorks'

    belongs_to :user
    has_many :areas, dependent: :destroy
    has_many :items, dependent: :destroy
    has_many :game_sessions, dependent: :destroy

    validates :title, presence: true
    validates :state, inclusion: {in: %w[draft published archived], message: "%{value} is not a valid state"}

    scope :published, -> {where(state: 'published', published: true)}
    scope :by_user, ->(user) {where(user: user)}

    def publish!
      update!(state: 'published', published: true, published_at: Time.current)
    end

    def start_area
      areas.find_by(start: true)
    end
  end
end