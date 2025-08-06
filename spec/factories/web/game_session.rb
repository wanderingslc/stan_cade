FactoryBot.define do
  factory :web_game_session, class: 'Web::GameSession' do
    game_state_flags {{}}

    association :user
    association :soork, factory: :web_soork
    association :current_area, factory: :web_area

    trait :anonymous do
      user {nil}
    end

    trait :with_flags do
      game_state_flags {{tutorial_complete: true, boss_defeated: false}}
    end
  end
end
