FactoryBot.define do
  factory :post do
    contents { "これはテスト。テストなのです。" }
    image { "imageUrl(640, 480, 'cats')" }
    user
  end
end
