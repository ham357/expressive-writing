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
    context 'インスタンス変数の値が正常か' do
      let(:other_user) { create(:user) }
      let!(:test_posts) do
        [
          test_post,
          create(:post, contents: "テストA", user_id: user.id),
          create(:post, contents: "テストB", user_id: user.id),
          create(:post, contents: "テストC", user_id: other_user.id)
        ]
      end

      it "params[:user_id] インスタンス変数の値が正常か" do
        posts = Post.where(user_id: user.id).order("created_at DESC")
        get :index, params: { user_id: user.id }
        expect(assigns(:posts)).to match_array(posts)
      end

      it "params[:tag] インスタンス変数の値が正常か" do
        test_posts[0].tag_list.add("TagTest")
        test_posts[3].tag_list.add("TagTest")
        test_posts[0].save
        test_posts[3].save
        test_posts[0].reload
        test_posts[3].reload
        posts = Post.tagged_with("TagTest").order("created_at DESC")
        get :index, params: { tag: "TagTest" }
        expect(assigns(:posts)).to match_array(posts)
      end

      it "インスタンス変数の値が正常か" do
        get :index
        expect(assigns(:posts)).to match(test_posts)
      end
    end

    it "ビューに正しく遷移できているか" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    it 'リクエストが成功しているか' do
      get :new
      expect(response.status).to eq 200
    end

    it 'newテンプレートが表示されているか' do
      get :new
      expect(response).to render_template :new
    end

    it '@postがnewされているか' do
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
    context 'パラメータが妥当な場合' do
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

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        patch :update, params: { id: test_post.id, post: attributes_for(:post, contents: "") }
        expect(response.status).to eq 200
      end

      it '投稿内容が変更されないこと' do
        expect do
          put :update, params: { id: test_post.id, post: attributes_for(:post, contents: "") }
        end.to_not change(Post.find(test_post.id), :contents)
      end

      it 'editテンプレートで表示されること' do
        put :update, params: { id: test_post.id, post: attributes_for(:post, contents: "") }
        expect(response).to render_template :edit
      end

      it 'エラーが表示されること' do
        put :update, params: { id: test_post.id, post: attributes_for(:post, contents: "") }
        expect(assigns(:post).errors.any?).to be_truthy
      end
    end
  end

  describe '#create' do
    context 'パラメータが妥当な場合' do
      it "投稿内容が保存できているか" do
        expect do
          post :create, params: { post: attributes_for(:post) }
        end.to change(Post, :count).by(1)
      end

      it "tagが正常に保存できているか" do
        expect do
          test_post.tag_list.add("タグテスト")
          test_post.save
          test_post.reload
        end.to change(test_post.tags, :count).by(1)
                                             .and change(test_post.taggings, :count).by(1)
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
        end.to_not change(Post, :count)
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
