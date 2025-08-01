FactoryBot.define do
  factory :web_soork, class: 'Web::Soork' do
    title {'The Mysterious Castle'}
    description {'A thrilling adventure in a haunted castle.'}
    state {'draft'}
    published {false}
    published_at {nil}

    association :user 

    trait :published do
      state {'published' }
      published {true}
      published_at {1.hour.ago}
    end

    trait :archived do
      state {'archived'}
      published {false}
    end
  end
end