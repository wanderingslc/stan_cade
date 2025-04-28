# == Schema Information
#
# Table name: player_items
#
#  id                 :integer          not null, primary key
#  soork_player_id    :integer          not null
#  item_id            :integer          not null
#  uses_remaining     :integer
#  current_durability :integer
#  equipped           :boolean
#  acquired_at        :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryBot.define do
  factory :player_item do
    soork_player
    item
    add_attribute(:uses_remaining) { 3 }
    add_attribute(:current_durability) { 100 }
    add_attribute(:equipped) { false }
    add_attribute(:acquired_at) { Time.current }

    trait :equipped do
      add_attribute(:equipped) { true }
    end

    trait :used do
      add_attribute(:uses_remaining) { 1 }
      add_attribute(:current_durability) { 25 }
    end

    trait :depleted do
      add_attribute(:uses_remaining) { 0 }
      add_attribute(:current_durability) { 0 }
    end
  end
end
