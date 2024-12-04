# spec/factories/rooms.rb
FactoryBot.define do
  factory :room do
    sequence(:name) { |n| "Room #{n}" }
    description { "A mysterious chamber with ancient walls" }
    first_visit_text { "You cautiously enter the room, dust stirring beneath your feet." }
    state { 'locked' }
    start_room { false }
    x { rand(0..10) }
    y { rand(0..10) }

    # Instead of automatic association, we'll make it required
    association :soork

    trait :start_room do
      name { "Starting Chamber" }
      start_room { true }
      state { 'unlocked' }
    end

    trait :unlocked do
      state { 'unlocked' }
    end

    # Dynamic trait for connections
    trait :with_connection do
      transient do
        direction { nil }
      end

      after(:create) do |room, evaluator|
        if evaluator.direction.present?
          connected_room = create(:room, soork: room.soork)
          create(:room_connection,
                 source_room: room,
                 target_room: connected_room,
                 direction: evaluator.direction)
        end
      end
    end
  end
end