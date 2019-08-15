User.create!(nickname: 'テストユーザ', email: 'test@example.com', image: File.open("spec/factories/no_image.jpg"), password: 'aaaaaaaa')

5.times do
  nickname             = Faker::Games::Pokemon.name
  email                = Faker::Internet.email
  image = File.open("spec/factories/no_image.jpg")
  password = Faker::Internet.password

  User.create!(nickname: nickname,
               email: email,
               image: image,
               password: password,
               password_confirmation: password)
end

100.times do
  title = Takarabako.open
  contents = Faker::Lorem.sentence
  image = File.open("spec/factories/no_image.jpg")
  user_id = Faker::Number.within(1..6)

  Post.create!(title: title,
               contents: contents,
               image: image,
               user_id: user_id)
end

(1..50).each do |_n|
  comment       = Faker::Lorem.sentence
  user_id       = Faker::Number.within(1..6)
  post_id       = Faker::Number.within(1..100)

  Comment.create!(comment: comment,
                  user_id: user_id,
                  post_id: post_id)
end
