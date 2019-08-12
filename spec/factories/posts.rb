FactoryBot.define do
  factory :post do
    title { "テストなのです。" }
    contents { "これはテスト。テストなのです。" }
    image { File.open("spec/factories/no_image.jpg") }
    user
  end
end
