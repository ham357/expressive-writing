FactoryBot.define do
  factory :post do
    contents { "これはテスト。テストなのです。" }
    image { File.open("#{Rails.root}/public/uploads/no_image.jpg") }
    user
  end
end
