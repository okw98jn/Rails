FactoryBot.define do
  factory :post do
    title { "カレー" }
    description { "美味しいカレーです" }
    post_image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    time { "10分" }
    number_of_persons { "1人前" }
    user_id { FactoryBot.create(:user).id }
  end
end
