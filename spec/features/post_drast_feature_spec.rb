require 'rails_helper'

feature '記事投稿', type: :feature do
  let(:user) { create(:user) }

  context '「下書き保存」をクリックした場合' do
    scenario '正常に下書きが作成できているか' do
      sign_in user
      visit root_path
      visit new_post_draft_path
      expect(current_path).to eq new_post_draft_path

      expect do
        fill_in 'post_draft_title', with: 'タイトルテスト'
        fill_in 'post_draft_contents', with: 'コンテンツテスト'
        attach_file 'post_draft_image', 'spec/factories/no_image.jpg'
        click_on '下書き保存'
      end.to change(PostDraft, :count).by(1)
    end
  end

  context '「投稿」をクリックした場合' do
    scenario '正常に投稿できているか' do
      sign_in user
      visit root_path
      visit new_post_draft_path
      expect(current_path).to eq new_post_draft_path

      expect do
        fill_in 'post_draft_title', with: 'タイトルテスト'
        fill_in 'post_draft_contents', with: 'コンテンツテスト'
        attach_file 'post_draft_image', 'spec/factories/no_image.jpg'
        click_on '投稿'
      end.to change(Post, :count).by(1)
    end
  end

  context '自動下書き保存機能', js: true do
    scenario '正常に下書き保存できているか' do
      sign_in user
      visit root_path
      visit new_post_draft_path
      expect(current_path).to eq new_post_draft_path

      expect do
        fill_in 'post_draft_title', with: 'タイトルテスト'
        fill_in 'post_draft_contents', with: 'コンテンツテスト'
        sleep 4
      end.to change(PostDraft, :count).by(1)
    end
  end
end

feature '記事更新', type: :feature do
  let(:user) { create(:user) }
  let(:test_post_draft) { create(:post_draft, user_id: user.id) }

  context '「下書き保存」をクリックした場合' do
    scenario '正常に更新できているか' do
      sign_in user
      visit root_path
      visit edit_post_draft_path(test_post_draft.id)
      expect(current_path).to eq edit_post_draft_path(test_post_draft.id)

      expect do
        fill_in 'post_draft_contents', with: '変更しました'
        click_on '下書き保存'
        test_post_draft.reload
      end.to change { test_post_draft.contents }.from('これはテスト。テストなのです。').to('変更しました')
      expect(current_path).to eq post_draft_path(test_post_draft.id)
    end
  end

  context '「投稿」をクリックした場合' do
    scenario '正常に投稿できているか。また下書きが削除されているか' do
      sign_in user
      visit root_path
      visit edit_post_draft_path(test_post_draft.id)
      expect(current_path).to eq edit_post_draft_path(test_post_draft.id)

      expect do
        fill_in 'post_draft_contents', with: '変更しました'
        click_on '投稿'
      end.to change(Post, :count).by(1)
                                 .and change(PostDraft, :count).by(-1)
      expect(current_path).to eq root_path
    end
  end

  context '自動下書き保存機能', js: true do
    scenario '正常に下書きが更新できているか' do
      sign_in user
      visit root_path
      visit edit_post_draft_path(test_post_draft.id)
      expect(current_path).to eq edit_post_draft_path(test_post_draft.id)

      expect do
        fill_in 'post_draft_title', with: '変更しました'
        fill_in 'post_draft_contents', with: '変更しました'
        sleep 5
        test_post_draft.reload
      end.to change { test_post_draft.contents }.from('これはテスト。テストなのです。').to('変更しました')
    end
  end
end

feature '記事削除', type: :feature do
  scenario '正常に削除できているか', js: true do
    user = create(:user)
    test_post_draft = create(:post_draft, user_id: user.id)

    sign_in user
    visit root_path

    visit post_draft_path(test_post_draft)
    expect(current_path).to eq post_draft_path(test_post_draft)
    expect do
      find('.post-draft-destroy').click
      sleep 1
      expect(page.driver.browser.switch_to.alert.text).to eq '削除いたします。よろしいですか?'
      page.driver.browser.switch_to.alert.accept
      sleep 1
    end.to change(PostDraft, :count).by(-1)
  end
end
