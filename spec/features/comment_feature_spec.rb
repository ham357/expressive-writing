require 'rails_helper'

feature 'コメント投稿', type: :feature do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }

  context 'パラメータが妥当な場合' do
    scenario '正常に投稿できているか' do
      sign_in user
      visit post_path(test_post)
      expect(current_path).to eq post_path(test_post)

      expect do
        fill_in 'comment_comment', with: 'コメントテスト'
        find('[type="submit"]').click
      end.to change(Comment, :count).by(1)
    end
  end

  context 'パラメータが不正な場合' do
    scenario 'コンテンツが空のため保存できていないか' do
      sign_in user
      visit post_path(test_post)
      expect(current_path).to eq post_path(test_post)

      expect do
        fill_in 'comment_comment', with: ''
        find('[type="submit"]').click
      end.to change(Comment, :count).by(0)
    end
  end
end
