require 'rails_helper'

feature 'お気に入り一覧', type: :feature do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }
  let!(:favorite) { create(:favorite, post_id: test_post.id, user_id: user.id) }

  scenario '正常にお気に入り一覧表示ができているか' do
    sign_in user
    visit favorites_path
    expect(current_path).to eq favorites_path

    expect(page).to have_content 'テストなのです。'
  end
end

feature 'お気に入り投稿', type: :feature, js: true do
  let(:user) { create(:user) }
  let!(:test_post) { create(:post, user_id: user.id) }

  scenario '正常にお気に入り投稿できているか' do
    sign_in user
    visit post_path(test_post)
    expect(current_path).to eq post_path(test_post)

    expect do
      find(".star").click
      sleep 1
    end.to change(Favorite, :count).by(1)
  end
end

feature 'お気に入り削除', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }
  let!(:favorite) { create(:favorite, post_id: test_post.id, user_id: user.id) }

  scenario '正常にお気に入り削除できているか' do
    sign_in user
    visit post_path(test_post)
    expect(current_path).to eq post_path(test_post)
    favorite.reload

    expect do
      find(".star").click
      sleep 1
    end.to change(Favorite, :count).by(-1)
  end
end
