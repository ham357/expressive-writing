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
end
