FactoryBot.define do
  factory :room_connection do
    association :source_room, factory: :room
    association :target_room, factory: :room
    direction { %w[north south east west].sample }

    trait :north do
      direction { 'north' }
    end

    trait :south do
      direction { 'south' }
    end

    trait :east do
      direction { 'east' }
    end

    trait :west do
      direction { 'west' }
    end

    trait :same_soork do
    after(:build) do |connection|
      source_soork = connection.source_room.soork
      target_soork = connection.target_room.soork

      if source_soork != target_soork
        connection.target_room.update(soork: source_soork)
      end
    end
    end
  end
end
