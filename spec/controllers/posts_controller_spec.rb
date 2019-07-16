require 'rails_helper'

describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:post) { create(:post, user_id: user.id) }

  describe 'GET #index' do
    it "インスタンス変数の値が正常" do
      posts = create_list(:post, 3, user_id: user.id)
      get :index
      expect(assigns(:posts)).to match(posts)
    end

    it "ビューに正しく遷移できる" do
      get :index
      expect(response).to render_template :index
    end
  end
end
