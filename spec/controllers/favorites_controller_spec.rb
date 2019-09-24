require 'rails_helper'

describe FavoritesController, type: :controller do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    let!(:test_posts) { create_list(:post, 3, user_id: user.id) }
    let!(:favorites) do
      [
        create(:favorite, post_id: test_posts[0].id, user_id: user.id),
        create(:favorite, post_id: test_posts[1].id, user_id: user.id),
        create(:favorite, post_id: test_posts[2].id, user_id: user.id)
      ]
    end

    it "インスタンス変数の値が正常か" do
      user_favorites = user.favorites.order("created_at DESC")
      get :index
      expect(assigns(:favorites)).to match(user_favorites)
    end

    it "ビューに正しく遷移できているか" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe '#favorite' do
    context 'パラメータが妥当な場合' do
      it "お気に入りが保存できているか" do
        expect do
          post :favorite, params: {
            post_id: test_post.id
          }
        end.to change(Favorite, :count).by(1)
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post :favorite, params: {
          post_id: test_post.id
        }
        expect(response.status).to eq 200
      end

      it 'お気に入りが登録されないこと' do
        create(:favorite, post_id: test_post.id, user_id: user.id)
        expect do
          post :favorite, params: {
            post_id: test_post.id, user_id: user.id
          }
        end.to_not change(Favorite, :count)
      end
    end
  end

  describe '#unfavorite' do
    it "お気に入りが削除されているか" do
      create(:favorite, post_id: test_post.id, user_id: user.id)
      expect do
        delete :unfavorite, params: {
          post_id: test_post.id
        }
      end.to change(Favorite, :count).by(-1)
    end
  end
end
