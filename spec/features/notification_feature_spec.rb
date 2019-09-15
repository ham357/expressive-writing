require 'rails_helper'

feature '通知一覧機能', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }
  let(:comment) { create(:comment, post_id: test_post.id, user_id: user.id) }
  let(:comment_like) { create(:comment_like, user_id: user.id, comment_id: comment.id) }
  let!(:notifications) do
    [
      create(:notification, visiter_id: other_user.id, visited_id: user.id, post_id: test_post.id, action: "like"),
      create(:notification, visiter_id: other_user.id, visited_id: user.id, comment_id: comment.id, action: "comment"),
      create(:notification, visiter_id: other_user.id, visited_id: user.id, action: "follow"),
      create(:notification, visiter_id: other_user.id, visited_id: user.id, post_id: test_post.id, comment_id: comment.id, action: "comment_like")
    ]
  end

  scenario '正常に通知一覧が表示されているか' do
    sign_in user
    visit root_path
    expect(current_path).to eq root_path
    visit current_path

    find('.notifications').click
    expect(find('.notifications-contents', visible: true)).to be_visible
  end

  scenario '表示された通知一覧が正常に非表示されているか' do
    sign_in user
    visit root_path
    expect(current_path).to eq root_path
    visit current_path

    find('.notifications').click
    expect(find('.notifications-contents', visible: true)).to be_visible

    find('.page-footer').click
    expect(find('.notifications-contents', visible: false)).to_not be_visible
  end

  scenario '通知一覧のユーザ名をクリックした時、そのユーザのプロフィールページが表示されているか' do
    sign_in user
    visit root_path
    expect(current_path).to eq root_path
    visit current_path

    find('.notifications').click
    expect(find('.notifications-contents', visible: true)).to be_visible
    page.within_frame 'notifications-contents' do
      first('.user-view').click_link other_user.nickname
      expect(current_path).to eq user_path(other_user)
    end
  end

  scenario '通知一覧の「あなたの投稿」をクリックした時、該当の投稿ページが表示されているか' do
    sign_in user
    visit root_path
    expect(current_path).to eq root_path
    visit current_path

    find('.notifications').click
    expect(find('.notifications-contents', visible: true)).to be_visible
    page.within_frame 'notifications-contents' do
      sleep 1
      first('.user-view').click_link 'あなたの投稿'
      expect(current_path).to eq post_path(test_post)
    end
  end

  scenario '通知一覧の「この記事」をクリックした時、該当の記事ページが表示されているか' do
    sign_in user
    visit root_path
    expect(current_path).to eq root_path
    visit current_path

    find('.notifications').click
    expect(find('.notifications-contents', visible: true)).to be_visible
    page.within_frame 'notifications-contents' do
      click_link 'この記事'
      expect(current_path).to eq post_path(test_post)
    end
  end
end
