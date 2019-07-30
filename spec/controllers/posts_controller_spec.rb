require 'rails_helper'

describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }
  let(:update_attributes) do
    {
      contents: "変更しました"
    }
  end

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

  describe '#show' do
    context 'viewが表示できているか' do
      it 'showのテンプレートが表示されてるか' do
        post = create(:post, user_id: user.id)
        get :show, params: { id: post.id }
        expect(response).to render_template :show
      end
      it '投稿内容が正常に表示できているか' do
        post = create(:post, user_id: user.id, contents: 'あああ')
        get :show, params: { id: post.id }
        expect(assigns(:post).contents).to eq "あああ"
      end
    end
  end

  describe '#destroy' do
    it "投稿が削除されているか" do
      post = create(:post, user_id: user.id)
      expect do
        delete :destroy, params: { id: post.id }
      end.to change(Post, :count).by(-1)
    end
  end

  describe '#update' do
    it "投稿内容が更新できているか" do
      patch :update, params: { id: test_post.id, post: update_attributes }
      test_post.reload
      expect(test_post.contents).to eq("変更しました")
    end

    it "正常にトップページへリダイレクトされているか" do
      patch :update, params: { id: test_post.id, post: update_attributes }
      expect(response).to redirect_to root_path
    end
  end

  describe '#create' do
    context 'パラメータが妥当な場合' do
      it "投稿内容が保存できているか" do
        expect do
          post :create, params: { post: attributes_for(:post) }
        end.to change(Post, :count).by(1)
      end

      it "正常にトップページへリダイレクトされているか" do
        post :create, params: { post: attributes_for(:post) }
        expect(response).to redirect_to root_path
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post :create, params: { post: attributes_for(:post, contents: "") }
        expect(response.status).to eq 200
      end

      it '投稿が登録されないこと' do
        expect do
          post :create, params: { post: attributes_for(:post, contents: "") }
        end.to_not change(User, :count)
      end

      it 'newテンプレートで表示されること' do
        post :create, params: { post: attributes_for(:post, contents: "") }
        expect(response).to render_template :new
      end

      it 'エラーが表示されること' do
        post :create, params: { post: attributes_for(:post, contents: "") }
        expect(assigns(:post).errors.any?).to be_truthy
      end
    end
  end

  describe 'GET #edit' do
    it 'リクエストが成功すること' do
      get :edit, params: { id: test_post.id }
      expect(response.status).to eq 200
    end

    it 'editテンプレートで表示されること' do
      get :edit, params: { id: test_post.id }
      expect(response).to render_template :edit
    end
  end
end
