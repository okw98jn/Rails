FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "#{n}hoge" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }
  end
end
