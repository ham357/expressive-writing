require 'rails_helper'

describe PostDraftsController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    let!(:test_post_draft) { create_list(:post_draft, 3, user_id: user.id) }

    it "インスタンス変数の値が正常か" do
      post_draft_last = user.post_drafts.order("updated_at").last
      get :index
      expect(assigns(:post_draft_last)).to match(post_draft_last)
    end

    it "ビューに正しく遷移できているか" do
      post_draft_last = user.post_drafts.order("updated_at").last
      get :index
      expect(response).to redirect_to post_draft_path(post_draft_last.id)
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

    it '@post_draftがnewされているか' do
      get :new
      expect(assigns(:post_draft)).to_not be_nil
    end
  end

  describe '#show' do
    context 'viewが表示できているか' do
      it 'showのテンプレートが表示されてるか' do
        post_draft = create(:post_draft, user_id: user.id)
        get :show, params: { id: post_draft.id }
        expect(response).to render_template :show
      end
      it '投稿内容が正常に表示できているか' do
        post_draft = create(:post_draft, user_id: user.id, contents: 'あああ')
        get :show, params: { id: post_draft.id }
        expect(assigns(:post_draft).contents).to eq "あああ"
      end
    end
  end

  describe '#destroy' do
    it "投稿が削除されているか" do
      post_draft = create(:post_draft, user_id: user.id)
      expect do
        delete :destroy, params: { id: post_draft.id }
      end.to change(PostDraft, :count).by(-1)
    end
  end

  describe '#update' do
    let(:test_post_draft) { create(:post_draft, user_id: user.id) }
    let(:update_attributes) do
      {
        contents: "変更しました"
      }
    end

    context '下書き保存の場合' do
      context 'パラメータが妥当な場合' do
        it "下書きが更新できているか" do
          patch :update, params: { id: test_post_draft.id, post_draft: update_attributes, commit: 'draft' }
          test_post_draft.reload
          expect(test_post_draft.contents).to eq("変更しました")
        end

        it "下書きページへリダイレクトされているか" do
          patch :update, params: { id: test_post_draft.id, post_draft: update_attributes, commit: 'draft' }
          expect(response).to redirect_to post_draft_path(test_post_draft.id)
        end
      end

      context 'パラメータが不正な場合' do
        it 'リクエストが成功すること' do
          patch :update, params: { id: test_post_draft.id, post_draft: attributes_for(:post_draft, contents: ('a' * 1001).to_s), commit: 'draft' }
          expect(response.status).to eq 302
        end

        it '下書きが変更されないこと' do
          expect do
            put :update, params: { id: test_post_draft.id, post_draft: attributes_for(:post_draft, contents: ('a' * 1001).to_s, commit: 'draft') }
            test_post_draft.reload
          end.to_not change(PostDraft.find(test_post_draft.id), :contents)
        end

        it 'トップページへリダイレクトされること' do
          put :update, params: { id: test_post_draft.id, post_draft: attributes_for(:post_draft, contents: ('a' * 1001).to_s, commit: 'draft') }
          expect(response).to redirect_to root_path
        end
      end
    end

    context '投稿の場合' do
      context 'パラメータが妥当な場合' do
        it "投稿ができているか。また下書きが削除されているか" do
          test_post_draft.reload
          expect do
            patch :update, params: { id: test_post_draft.id, post_draft: update_attributes, commit: 'save' }
          end.to change(Post, :count).by(1)
                                     .and change(PostDraft, :count).by(-1)
        end

        it "トップページへリダイレクトされているか" do
          patch :update, params: { id: test_post_draft.id, post_draft: update_attributes, commit: 'save' }
          expect(response).to redirect_to root_path
        end
      end

      context 'パラメータが不正な場合' do
        it 'リクエストが成功すること' do
          patch :update, params: { id: test_post_draft.id, post_draft: attributes_for(:post_draft, contents: ('a' * 1001).to_s), commit: 'save' }
          expect(response.status).to eq 302
        end

        it '投稿内容が変更されないこと' do
          expect do
            put :update, params: { id: test_post_draft.id, post_draft: attributes_for(:post_draft, contents: ('a' * 1001).to_s, commit: 'save') }
            test_post_draft.reload
          end.to_not change(PostDraft.find(test_post_draft.id), :contents)
        end

        it 'トップページへリダイレクトされること' do
          put :update, params: { id: test_post_draft.id, post_draft: attributes_for(:post_draft, contents: ('a' * 1001).to_s, commit: 'save') }
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe '#create' do
    context '下書き保存の場合' do
      context 'パラメータが妥当な場合' do
        it "投稿内容が保存できているか" do
          expect do
            post :create, params: { post_draft: attributes_for(:post_draft), commit: 'draft' }
          end.to change(PostDraft, :count).by(1)
        end

        it "tagが正常に保存できているか" do
          test_post_draft = create(:post_draft, user_id: user.id)

          expect do
            test_post_draft.tag_list.add("タグテスト")
            test_post_draft.save
            test_post_draft.reload
          end.to change(test_post_draft.tags, :count).by(1)
                                                     .and change(test_post_draft.taggings, :count).by(1)
        end

        it "下書き一覧へリダイレクトされること" do
          post :create, params: { post_draft: attributes_for(:post_draft), commit: 'draft' }
          post_draft_last = user.post_drafts.order("updated_at").last
          expect(response).to redirect_to post_draft_path(post_draft_last.id)
        end
      end

      context 'パラメータが不正な場合' do
        it 'リクエストが成功すること' do
          post :create, params: { post_draft: attributes_for(:post_draft, contents: ('a' * 1001).to_s, commit: 'draft') }
          expect(response.status).to eq 200
        end

        it '投稿が登録されないこと' do
          expect do
            post :create, params: { post_draft: attributes_for(:post_draft, contents: ('a' * 1001).to_s, commit: 'draft') }
          end.to_not change(PostDraft, :count)
        end

        it 'newテンプレートで表示されること' do
          post :create, params: { post_draft: attributes_for(:post_draft, contents: ('a' * 1001).to_s, commit: 'draft') }
          expect(response).to render_template :new
        end
      end
    end

    context '投稿の場合' do
      context 'パラメータが妥当な場合' do
        it "投稿内容が保存できているか" do
          expect do
            post :create, params: { post_draft: attributes_for(:post_draft), commit: 'save' }
          end.to change(Post, :count).by(1)
        end

        it "tagが正常に保存できているか" do
          test_post = create(:post, user_id: user.id)

          expect do
            test_post.tag_list.add("タグテスト")
            test_post.save
            test_post.reload
          end.to change(test_post.tags, :count).by(1)
                                               .and change(test_post.taggings, :count).by(1)
        end

        it "トップページへリダイレクトされること" do
          post :create, params: { post_draft: attributes_for(:post_draft), commit: 'save' }
          expect(response).to redirect_to root_path
        end
      end

      context 'パラメータが不正な場合' do
        it 'リクエストが成功すること' do
          post :create, params: { post_draft: attributes_for(:post_draft, contents: ('a' * 1001).to_s, commit: 'save') }
          expect(response.status).to eq 200
        end

        it '投稿が登録されないこと' do
          expect do
            post :create, params: { post_draft: attributes_for(:post_draft, contents: ('a' * 1001).to_s, commit: 'save') }
          end.to_not change(Post, :count)
        end

        it 'newテンプレートで表示されること' do
          post :create, params: { post_draft: attributes_for(:post_draft, contents: ('a' * 1001).to_s, commit: 'save') }
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'GET #edit' do
    let(:test_post_draft) { create(:post_draft, user_id: user.id) }

    it 'リクエストが成功すること' do
      get :edit, params: { id: test_post_draft.id }
      expect(response.status).to eq 200
    end

    it 'editテンプレートで表示されること' do
      get :edit, params: { id: test_post_draft.id }
      expect(response).to render_template :edit
    end
  end
end
