FactoryBot.define do
  factory :web_area, class: 'Web::Area' do
    name { "Test Area" }
    description { "This is a test area." }
    start_area { false }
    association :soork, factory: :web_soork

    trait :start_area do
      start_area { true }
    end
  end
end
