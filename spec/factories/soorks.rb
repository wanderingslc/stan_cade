
FactoryBot.define do
  factory :soork do
    sequence(:title) {|n| "Adventure #{n}"}
    description {"A thrilling text adventure"}
    association :user
    state {'draft'}
    published { false }
    published_at { nil }

    trait :published do
      state {'published'}
      published { true }
      published_at { Time.now }
    end

    trait :testing do
      state {'testing'}
    end

    trait :archived do
      state {'archived'}
    end

    factory :soork_with_rooms do
      transient do
        rooms_count {2}
        end
        after(:create) do |soork, evaluator|
          create(:room, :start_room, soork: soork)
          create_list(:room, evaluator.rooms_counts - 1,soork: soork )
        end
      end

  end
end
