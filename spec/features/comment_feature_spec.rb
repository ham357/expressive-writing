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

feature 'コメント更新', type: :feature do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }
  let(:comment) { create(:comment, post_id: test_post.id, user_id: user.id) }

  context 'パラメータが妥当な場合' do
    scenario '正常に更新できているか', js: true do
      sign_in user
      visit post_path(test_post)
      expect(current_path).to eq post_path(test_post)
      comment.reload
      visit current_path

      find('.commnet-edit').click
      expect do
        fill_in "comment-edit-textbox", with: "変更しました"
        find('.comment-edit-savebtn').click
        sleep 1
        comment.reload
      end.to change { comment.comment }.from("コメントテストなのです。").to("変更しました")
    end
  end

  context 'パラメータが不正な場合' do
    scenario 'コメントが空のため保存できていないか', js: true do
      sign_in user
      visit post_path(test_post)
      expect(current_path).to eq post_path(test_post)
      comment.reload
      visit current_path

      find('.commnet-edit').click
      expect do
        fill_in "comment-edit-textbox", with: ""
        find('.comment-edit-savebtn').disabled?
        sleep 1
        comment.reload
      end.not_to change { comment.comment }.from("コメントテストなのです。")
    end
  end
end

feature 'コメント削除', type: :feature do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }
  let(:comment) { create(:comment, post_id: test_post.id, user_id: user.id) }

  scenario '正常に削除できているか', js: true do
    sign_in user
    visit post_path(test_post)
    expect(current_path).to eq post_path(test_post)
    comment.reload
    visit current_path

    expect do
      find('.commnet-destroy').click
      expect(page.driver.browser.switch_to.alert.text).to eq "削除してよろしいでしょうか？"
      page.driver.browser.switch_to.alert.accept
      sleep 1
    end.to change(Comment, :count).by(-1)
  end
end
