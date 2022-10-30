FactoryBot.define do
  factory :comment do
    association :user
    association :post
    body { "コメントしました" }
  end
end
