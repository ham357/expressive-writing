require 'rails_helper'

feature 'user', type: :feature do
  let(:user) { create(:user) }

  scenario 'My pageボタン表示' do
    visit root_path
    expect(page).to have_no_css('.mypage')

    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find('#login').click
    expect(current_path).to eq root_path
    expect(page).to have_css('.mypage')
  end

  scenario 'Log outボタン表示' do
    visit root_path
    expect(page).to have_no_content('ログアウト')

    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find('#login').click
    expect(current_path).to eq root_path
    expect(page).to have_content('ログアウト')
  end

  scenario 'Log in処理' do
    visit root_path
    click_on 'ログイン'

    expect(current_path).to eq new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find('#login').click
    expect(current_path).to eq root_path
  end

  scenario 'ユーザ一覧の表示' do
    sign_in user
    visit root_path
    find('.mypage').click
    click_on 'ユーザ一覧'

    expect(current_path).to eq users_path
  end

  scenario 'プロフィールページの表示' do
    sign_in user
    visit root_path
    find('.mypage').click
    click_on 'プロフィール'

    expect(current_path).to eq user_path(user.id)
  end

  scenario 'プロフィールコメントの変更' do
    sign_in user
    visit root_path
    find('.mypage').click
    click_on 'プロフィール'

    expect(current_path).to eq user_path(user.id)
    click_on 'プロフィールの変更'
    expect(current_path).to eq edit_user_registration_path
    expect do
      fill_in 'user_comment', with: "変更しました"
      find('#comment-submit').click
      user.reload
    end.to change { user.comment }.from("プロフィールコメントです。").to("変更しました")
    expect(current_path).to eq user_path(user.id)
  end

  scenario 'ユーザ検索ができる', js: true do
    sign_in user
    create(:user, nickname: 'アザーユーザ')
    visit root_path
    find('.mypage').click
    click_on 'ユーザ一覧'
    expect(current_path).to eq users_path

    fill_in 'user-search-field', with: 'アザーユーザ'
    expect(page).to have_content 'アザーユーザ'
  end

  describe "facebook連携でサインアップする" do
    before do
      OmniAuth.config.mock_auth[:facebook] = nil
      Rails.application.env_config['omniauth.auth'] = facebook_mock
      visit root_path
      click_on "ログイン"
    end

    it "サインアップするとユーザーが増える" do
      expect do
        click_on "Facebookアカウントでログイン"
      end.to change(User, :count).by(1)
    end

    it "すでに連携されたユーザーがサインアップしようとするとユーザーは増えない" do
      click_on "Facebookアカウントでログイン"
      sleep 1
      click_on "ログアウト"
      visit root_path
      click_on "ログイン"
      expect do
        click_on "Facebookアカウントでログイン"
      end.not_to change(User, :count)
    end
  end
  
  describe "twitter連携でサインアップする" do
    before do
      OmniAuth.config.mock_auth[:twitter] = nil
      Rails.application.env_config['omniauth.auth'] = twitter_mock
      visit root_path
      click_on "ログイン"
    end
    
    it "サインアップするとユーザーが増える" do
      expect do
        click_on "Twitterアカウントでログイン"
        sleep 1
      end.to change(User, :count).by(1)
    end
    
    it "すでに連携されたユーザーがサインアップしようとするとユーザーは増えない", js: true do
      click_on "Twitterアカウントでログイン"
      sleep 1
      click_on "ログアウト"
      expect(page.driver.browser.switch_to.alert.text).to eq "ログアウトいたしますか?"
      page.driver.browser.switch_to.alert.accept
      click_on "ログイン"
      expect do
        click_on "Twitterアカウントでログイン"
      end.not_to change(User, :count)
    end
  end
end
