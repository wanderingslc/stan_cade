# spec/factories/soork_players.rb
FactoryBot.define do
  factory :soork_player do
    association :current_room, factory: :room  # explicitly specify the factory
    association :soork
    add_attribute(:game_state_flags) { {} }
    add_attribute(:state) { 'active' }
    add_attribute(:requires_login) { false }
    add_attribute(:last_played_at) { Time.current }

    after(:build) do |player|
      player.current_room.update(soork: player.soork) if player.current_room.soork != player.soork
    end

    trait :requires_login do
      add_attribute(:requires_login) { true }
      association :user
    end

    trait :with_visited_rooms do
      after(:create) do |player|
        create(:room_visit, soork_player: player)
      end
    end

    trait :with_items do
      after(:create) do |player|
        create(:player_item, soork_player: player)
      end
    end
  end
end