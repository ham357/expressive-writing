require 'rails_helper'

feature '記事投稿', type: :feature do
  let(:user) { create(:user) }

  context 'パラメータが妥当な場合' do
    scenario '正常に投稿できているか' do
      sign_in user
      visit root_path
      visit new_post_path
      expect(current_path).to eq new_post_path
      visit current_path

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

feature 'SNSシェアボタンの表示', type: :feature do
  let(:user) { create(:user) }
  let!(:test_post) { create(:post, user_id: user.id) }

  context '一覧表示ページの場合' do
    before do
      sign_in user
      visit root_path
      expect(current_path).to eq root_path
    end

    scenario 'SNSシャアボタンが表示されているか' do
      expect(first('.modal-trigger', visible: true)).to be_visible
    end

    scenario 'モーダルが正常に表示されるか', js: true do
      execute_script("document.querySelectorAll('.modal-trigger')[0].click();")
      within_window(windows.last) do
        expect(page).to have_content 'SNSでシェアする'
      end
    end

    context 'モーダルが正常に表示された場合', js: true do
      before do
        execute_script("document.querySelectorAll('.modal-trigger')[0].click();")
      end

      scenario 'Twitterアイコンが表示されているか' do
        within_window(windows.last) do
          expect(find('.fa-twitter-square', visible: true)).to be_visible
        end
      end

      scenario 'Facebookアイコンが表示されているか' do
        within_window(windows.last) do
          expect(find('.fa-facebook-square', visible: true)).to be_visible
        end
      end

      scenario 'LINEアイコンが表示されているか' do
        within_window(windows.last) do
          expect(find('.fa-line', visible: true)).to be_visible
        end
      end

      context '各SNSアイコンが正常に表示された場合', js: true do
        scenario 'Tweetシェアボタンが正常に動作するか', js: true do
          link_url = first('a', text: '…詳しくはこちら')
          find('.twitter_btn').click
          twitter_content = test_post.title + " " + link_url[:href] + " #ExpressiveWriting"
          within_window(windows.last) do
            expect(page).to have_selector 'textarea', text: twitter_content
          end
        end

        scenario 'facebookシェアボタンが正常に動作するか', js: true do
          sleep 1
          find('.facebook_btn').click
          within_window(windows.last) do
            expect(current_url).to include 'facebook'
          end
        end

        scenario 'Lineシェアボタンが正常に動作するか', js: true do
          sleep 1
          find('.line_btn').click
          within_window(windows.last) do
            expect(current_url).to include 'line.me'
          end
        end
      end
    end
  end

  context '詳細ページの場合' do
    before do
      sign_in user
      visit post_path(test_post)
      expect(current_path).to eq post_path(test_post)
    end

    scenario 'ボタンが表示されているか', js: true do
      expect(find('.twitter-share-button', visible: true)).to be_visible
      expect(find('.facebook-share-button', visible: true)).to be_visible
      expect(find('.line-it-button', visible: true)).to be_visible
    end

    scenario 'Tweetシェアボタンが正常に動作するか', js: true do
      page.within_frame :css, '.twitter-share-button' do
        sleep 1
        execute_script("document.querySelectorAll('.btn')[0].click();")
      end
      twitter_content = test_post.title + " " + current_url + " #ExpressiveWriting"
      within_window(windows.last) do
        expect(page).to have_selector 'textarea', text: twitter_content
      end
    end

    scenario 'facebookシェアボタンが正常に動作するか', js: true do
      page.within_frame 'facebook-share-button' do
        sleep 1
        find('[type="submit"]').click
      end
      within_window(windows.last) do
        expect(current_url).to include 'facebook'
      end
    end

    scenario 'Lineシェアボタンが正常に動作するか', js: true do
      page.within_frame :css, '.line-it-button' do
        sleep 1
        find('.btn').click
      end
      within_window(windows.last) do
        expect(current_url).to include 'line.me'
      end
    end
  end

  feature '記事検索', type: :feature, js: true do
    let(:user) { create(:user) }
    let(:test_post) { create(:post, user_id: user.id) }

    context 'パラメータが妥当な場合' do
      scenario '正常に検索できているか' do
        sign_in user
        visit root_path
        expect(current_path).to eq root_path

        fill_in 'q_title_or_contents_has_every_term', with: test_post.title + "\n"
        expect(page).to have_content test_post.title

        expect(current_path).to eq search_posts_path
      end

      scenario '「title:」を使用して正常に検索できているか' do
        sign_in user
        visit root_path
        expect(current_path).to eq root_path

        fill_in 'q_title_or_contents_has_every_term', with: "title:" + test_post.title + "\n"
        expect(page).to have_content test_post.title

        expect(current_path).to eq search_posts_path
      end

      scenario '「contents:」を使用して正常に検索できているか' do
        sign_in user
        visit root_path
        expect(current_path).to eq root_path

        fill_in 'q_title_or_contents_has_every_term', with: "contents:" + test_post.contents + "\n"
        expect(page).to have_content test_post.contents

        expect(current_path).to eq search_posts_path
      end
    end

    context 'パラメータが不正な場合' do
      scenario '検索フォームに何も入力していない場合「該当はありません。」と表示されているか' do
        sign_in user
        visit root_path
        expect(current_path).to eq root_path
  
        fill_in 'q_title_or_contents_has_every_term', with: "" + "\n"
        expect(page).to have_content "該当はありません。"

        expect(current_path).to eq search_posts_path
      end

      scenario '検索結果に該当が無い場合「該当はありません。」と表示されているか' do
        sign_in user
        visit root_path
        expect(current_path).to eq root_path
  
        fill_in 'q_title_or_contents_has_every_term', with: "@@@@@@@" + "\n"
        expect(page).to have_content "該当はありません。"

        expect(current_path).to eq search_posts_path
      end
    end
  end
end
