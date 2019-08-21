require 'rails_helper'

feature 'フォローを行う', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:test_post) { create(:post, user_id: other_user.id) }

  scenario '正常にフォローできているか' do
    sign_in user
    visit post_path(test_post)
    expect(current_path).to eq post_path(test_post)
    visit current_path

    expect do
      click_button 'フォロー'
      sleep 1
    end.to change(Relationship, :count).by(1)
  end
end

feature 'フォロー解除', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:test_post) { create(:post, user_id: other_user.id) }
  let(:relationship) { create(:relationship, user_id: user.id, follow_id: other_user.id) }

  scenario '正常にフォロー解除できているか' do
    sign_in user
    visit post_path(test_post)
    expect(current_path).to eq post_path(test_post)
    relationship.reload
    visit current_path

    expect do
      click_button 'フォロー中'
      sleep 1
    end.to change(Relationship, :count).by(-1)
  end
end
