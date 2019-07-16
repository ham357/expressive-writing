FactoryBot.define do
  factory :post do
    contents { "これはテスト。テストなのです。" }
    image
    user_id
  end
end
