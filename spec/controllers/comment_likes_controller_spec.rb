require 'rails_helper'

describe CommentLikesController, type: :controller do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }
  let(:comment) { create(:comment, post_id: test_post.id, user_id: user.id) }

  before do
    sign_in user
  end

  describe '#like' do
    context 'パラメータが妥当な場合' do
      it "コメントのいいねが保存できているか" do
        expect do
          post :comment_like, params: {
            comment_id: comment.id
          }
        end.to change(CommentLike, :count).by(1)
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post :comment_like, params: {
          comment_id: comment.id
        }
        expect(response.status).to eq 200
      end

      it 'コメントのいいねが登録されないこと' do
        create(:comment_like, comment_id: comment.id, user_id: user.id)
        expect do
          post :comment_like, params: {
            comment_id: comment.id, user_id: user.id
          }
        end.to_not change(CommentLike, :count)
      end
    end
  end

  describe '#unlike' do
    it "コメントのいいねが削除されているか" do
      create(:comment_like, comment_id: comment.id, user_id: user.id)
      expect do
        delete :comment_unlike, params: {
          comment_id: comment.id
        }
      end.to change(CommentLike, :count).by(-1)
    end
  end
end
