require 'rails_helper'

feature 'user', type: :feature do
  let(:user) { create(:user) }

  scenario 'My pageボタン表示' do
    visit root_path
    expect(page).to have_no_content('マイページ')

    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find('#login').click
    expect(current_path).to eq root_path
    expect(page).to have_content('マイページ')
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
    click_on 'マイページ'
    click_on 'ユーザ一覧'

    expect(current_path).to eq users_path
  end

  scenario 'プロフィールページの表示' do
    sign_in user
    visit root_path
    click_on 'マイページ'
    click_on 'プロフィール'

    expect(current_path).to eq user_path(user.id)
  end

  scenario 'プロフィールコメントの変更' do
    sign_in user
    visit root_path
    click_on 'マイページ'
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
    click_on 'マイページ'
    click_on 'ユーザ一覧'
    expect(current_path).to eq users_path

    fill_in 'user-search-field', with: 'アザーユーザ'
    expect(page).to have_content 'アザーユーザ'
  end
end
