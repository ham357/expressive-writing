require 'rails_helper'

feature 'いいね投稿', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }

  scenario '正常にいいね投稿できているか' do
    sign_in user
    visit post_path(test_post)
    expect(current_path).to eq post_path(test_post)
    visit current_path

    expect do
      find(".heart").click
      sleep 1
    end.to change(Like, :count).by(1)
  end
end

feature 'いいね削除', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }
  let(:like) { create(:like, post_id: test_post.id, user_id: user.id) }

  scenario '正常にいいね削除できているか' do
    sign_in user
    visit post_path(test_post)
    expect(current_path).to eq post_path(test_post)
    like.reload
    visit current_path

    expect do
      find(".heart").click
      sleep 1
    end.to change(Like, :count).by(-1)
  end
end
