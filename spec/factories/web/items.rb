FactoryBot.define do
  factory :web_item, class: 'Web::Item' do
    name {'Ancient Scroll'}
    description {'A weathered scroll with mysterious writings.'}
    examine_text {'The scroll is covered in strange symbols that seem to glow.'}
    is_pickable {true}
    default_uses {100}
    default_durability {100}
    properties {{}}

    association :soork, factory: :web_soork
    association :area, factory: :web_area

    trait :not_pickable do
      is_pickable {false}
    end

    trait :consumable do
      default_uses {3}
    end

    trait :fragile do
      default_durability {10}
    end

    trait :unsassigned do
      area { nil }
    end
  end
end
