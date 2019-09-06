FactoryBot.define do
  factory :notification do
    user_id { 1 }
    sent_user_id { 1 }
    post_id { 1 }
    comment_id { 1 }
    action { "MyString" }
    checked { false }
  end
end
