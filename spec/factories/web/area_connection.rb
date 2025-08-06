FactoryBot.define do
  factory :web_area_connection, class: 'Web::AreaConnection' do
    direction {'north' }

    association :source_area, factory: :web_area
    association :target_area, factory: :web_area

    trait :north do
      direction {'north'}
    end

    trait :south do
      direction {'south'}
    end

    trait :east do
      direction {'east'}
    end

    trait :west do
      direction {'west'}
    end

  end
end