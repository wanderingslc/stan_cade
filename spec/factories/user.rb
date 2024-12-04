FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "User#{n}@example.com"}
    password {"password123"}
    password_confirmation {"password123"}
  end
end