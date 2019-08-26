FactoryBot.define do
  factory :post_draft do
    title { "テストなのです。" }
    contents { "これはテスト。テストなのです。" }
    image { File.open("spec/factories/no_image.jpg") }
    user
  end
end
