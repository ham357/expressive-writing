require 'rails_helper'

feature 'post', type: :feature do
  scenario '正常に投稿できる' do
    user = FactoryBot.create(:user)

    sign_in user
    visit root_path

    visit new_post_path
    expect(current_path).to eq new_post_path

    expect do
      fill_in 'post_title', with: 'タイトルテスト'
      fill_in 'post_contents', with: 'コンテンツテスト'
      attach_file "post_image", "#{Rails.root}/spec/factories/no_image.jpg"
      find('[type="submit"]').click
    end.to change(Post, :count).by(1)
  end
end
