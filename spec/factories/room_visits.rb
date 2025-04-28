# == Schema Information
#
# Table name: room_visits
#
#  id              :integer          not null, primary key
#  soork_player_id :integer          not null
#  room_id         :integer          not null
#  visit_count     :integer
#  last_visited_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

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
