require 'rails_helper'

describe LikesController, type: :controller do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }
  let(:comment) { create(:comment, post_id: test_post.id, user_id: user.id) }

  before do
    sign_in user
  end

  describe '#like' do
    context 'パラメータが妥当な場合' do
      it "いいねが保存できているか" do
        expect do
          post :like, params: {
            post_id: test_post.id
          }
        end.to change(Like, :count).by(1)
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post :like, params: {
          post_id: test_post.id
        }
        expect(response.status).to eq 200
      end

      it 'いいねが登録されないこと' do
        create(:like, post_id: test_post.id, user_id: user.id)
        expect do
          post :like, params: {
            post_id: test_post.id, user_id: user.id
          }
        end.to_not change(Like, :count)
      end
    end
  end

  describe '#unlike' do
    it "いいねが削除されているか" do
      create(:like, post_id: test_post.id, user_id: user.id)
      expect do
        delete :unlike, params: {
          post_id: test_post.id
        }
      end.to change(Like, :count).by(-1)
    end
  end
end
