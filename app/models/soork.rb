class Soork < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  has_many :rooms, dependent: :destroy
  has_many :items, through: :rooms

  include AASM

  aasm column: 'state' do
    state :draft, initial: true
    state :testing
    state :published
    state :archived

    event :begin_testing do
      transitions from: :draft, to: :testing
    end

    event :publish do
      transitions from: [:draft, :testing], to: :published
    end

    event :archive do
      transitions from: [:published, :draft], to: :archived
    end
  end
end
