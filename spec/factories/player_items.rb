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