FactoryBot.define do
  factory :user do
    name { "hoge" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }
  end
end
