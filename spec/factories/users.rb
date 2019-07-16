FactoryBot.define do
  factory :user do
    password = Faker::Internet.password
    nickname              { Faker::Games::Pokemon.name }
    email                 { Faker::Internet.email }
    password              { password }
    password_confirmation { password }
  end

  factory :other_user, class: User do
    password = Faker::Internet.password
    nickname              { Faker::Games::Pokemon.name }
    email                 { Faker::Internet.email }
    password              { password }
    password_confirmation { password }
  end
end
