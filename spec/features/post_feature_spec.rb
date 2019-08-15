require 'rails_helper'

feature '記事投稿', type: :feature do
  let(:user) { create(:user) }

  context 'パラメータが妥当な場合' do
    scenario '正常に投稿できているか' do
      sign_in user
      visit root_path
      visit new_post_path
      expect(current_path).to eq new_post_path

      expect do
        fill_in 'post_title', with: 'タイトルテスト'
        fill_in 'post_contents', with: 'コンテンツテスト'
        attach_file "post_image", "spec/factories/no_image.jpg"
        find('[type="submit"]').click
      end.to change(Post, :count).by(1)
    end
  end

  context 'パラメータが不正な場合' do
    scenario 'コンテンツが空のため保存できていないか' do
      sign_in user
      visit root_path
      visit new_post_path
      expect(current_path).to eq new_post_path

      expect do
        fill_in 'post_title', with: 'タイトルテスト'
        fill_in 'post_contents', with: ''
        attach_file "post_image", "spec/factories/no_image.jpg"
        find('[type="submit"]').click
      end.to change(Post, :count).by(0)
    end
  end
end

feature '記事更新', type: :feature do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }

  context 'パラメータが妥当な場合' do
    scenario '正常に更新できているか' do
      sign_in user
      visit root_path

      visit edit_post_path(test_post.id)
      expect(current_path).to eq edit_post_path(test_post.id)
      fill_in "post[contents]", with: "変更しました"
      expect  do
        find('[type="submit"]').click
        test_post.reload
      end.to change { test_post.contents }.from("これはテスト。テストなのです。").to("変更しました")
      expect(current_path).to eq root_path
    end
  end

  context 'パラメータが不正な場合' do
    scenario 'コンテンツが空のため保存できていないか' do
      sign_in user
      visit root_path

      visit edit_post_path(test_post.id)
      expect(current_path).to eq edit_post_path(test_post.id)
      fill_in "post[contents]", with: ""
      expect  do
        find('[type="submit"]').click
        test_post.reload
      end.not_to change { test_post.contents }.from("これはテスト。テストなのです。")
      expect(current_path).to eq post_path(test_post.id)
    end
  end
end

feature '記事削除', type: :feature do
  scenario '正常に削除できているか', js: true do
    user = create(:user)
    test_post = create(:post, user_id: user.id)

    sign_in user
    visit root_path

    visit post_path(test_post)
    expect(current_path).to eq post_path(test_post)
    expect do
      find('.post-destroy').click
      sleep 1
      expect(page.driver.browser.switch_to.alert.text).to eq "削除いたします。よろしいですか?"
      page.driver.browser.switch_to.alert.accept
      sleep 1
    end.to change(Post, :count).by(-1)
  end
end
