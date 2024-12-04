# spec/factories/items.rb
FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item #{n}" }
    description { "A curious object that catches your attention" }
    examine_text { "Upon closer inspection, you notice intricate details" }
    :room
    is_pickable { true }
    state { 'inactive' }
    properties { {} }

    trait :active do
      state { 'active' }
    end

    trait :used do
      state { 'used' }
    end

    trait :broken do
      state { 'broken' }
    end

    trait :fixed do
      is_pickable { false }
    end

    trait :key do
      name { "Brass Key" }
      description { "A weathered brass key" }
      examine_text { "The key has unusual markings" }
      properties { { unlocks: "door" } }
    end
  end
end