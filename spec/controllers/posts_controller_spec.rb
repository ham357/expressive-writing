require 'rails_helper'

describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:post) { create(:post, user_id: user.id) }
  before do
    sign_in user
  end
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

  describe 'GET #new' do
    it 'リクエストが成功すること' do
      get :new
      expect(response.status).to eq 200
    end

    it 'newテンプレートで表示されること' do
      get :new
      expect(response).to render_template :new
    end

    it '@postがnewされていること' do
      get :new
      expect(assigns(:post)).to_not be_nil
    end
  end
end
