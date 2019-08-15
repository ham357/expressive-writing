FactoryBot.define do
  factory :comment do
    comment { "コメントテストなのです。" }
    post
    user
  end
end
