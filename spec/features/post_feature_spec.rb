require 'rails_helper'

feature '記事投稿', type: :feature do
  context 'パラメータが妥当な場合' do
    scenario '正常に投稿できているか' do
      user = create(:user)

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

  context 'パラメータが不正な場合' do
    scenario 'コンテンツが空のため保存できていないか' do
      user = create(:user)

      sign_in user
      visit root_path

      visit new_post_path
      expect(current_path).to eq new_post_path

      expect do
        fill_in 'post_title', with: 'タイトルテスト'
        fill_in 'post_contents', with: ''
        attach_file "post_image", "#{Rails.root}/spec/factories/no_image.jpg"
        find('[type="submit"]').click
      end.to change(Post, :count).by(0)
    end
  end
end
