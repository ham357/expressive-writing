require 'rails_helper'

feature 'コメントいいね投稿', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }
  let(:comment) { create(:comment, post_id: test_post.id, user_id: user.id) }

  scenario '正常にコメントいいね投稿できているか' do
    sign_in user
    visit post_path(test_post)
    expect(current_path).to eq post_path(test_post)
    comment.reload
    visit current_path

    expect do
      find(".comment-heart").click
      sleep 1
    end.to change(CommentLike, :count).by(1)
  end
end

feature 'コメントいいね削除', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }
  let(:comment) { create(:comment, post_id: test_post.id, user_id: user.id) }
  let(:comment_like) { create(:comment_like, comment_id: comment.id, user_id: user.id) }

  scenario '正常にコメントいいね削除できているか' do
    sign_in user
    visit post_path(test_post)
    expect(current_path).to eq post_path(test_post)
    comment.reload
    comment_like.reload
    visit current_path

    expect do
      find(".comment-heart").click
      sleep 1
    end.to change(CommentLike, :count).by(-1)
  end
end
