require 'rails_helper'

describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }

  before do
    sign_in user
  end

  describe '#create' do
    context 'パラメータが妥当な場合' do
      it "投稿内容が保存できているか" do
        expect do
          post :create, params: { comment: { comment: "コメントしました" },
                                  post_id: test_post.id,
                                  user_id: user.id }
        end.to change(Comment, :count).by(1)
      end

      it "正常にトップページへリダイレクトされているか" do
        post :create, params: { comment: { comment: "コメントしました" },
                                post_id: test_post.id,
                                user_id: user.id }
        expect(response).to redirect_to post_path(test_post.id)
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post :create, params: { comment: { comment: "" },
                                post_id: test_post.id,
                                user_id: user.id }
        expect(response.status).to eq 302
      end

      it '投稿が登録されないこと' do
        expect do
          post :create, params: { comment: { comment: "" },
                                  post_id: test_post.id,
                                  user_id: user.id }
        end.to_not change(Comment, :count)
      end
    end
  end
end
