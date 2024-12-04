FactoryBot.define do
  factory :room_visit do
    soork_player
    room
    add_attribute(:visit_count) { 1 }
    add_attribute(:last_visited_at) { Time.current }

    trait :multiple_visits do
      add_attribute(:visit_count) { rand(2..5) }
    end
  end
end