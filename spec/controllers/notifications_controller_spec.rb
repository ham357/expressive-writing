require 'rails_helper'

describe NotificationsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:test_post) { create(:post, user_id: user.id) }
  let(:comment) { create(:comment, post_id: test_post.id, user_id: user.id) }
  let!(:notifications) do
    [
      create(:notification, visiter_id: other_user.id, visited_id: user.id, post_id: test_post.id, action: "like"),
      create(:notification, visiter_id: other_user.id, visited_id: user.id, comment_id: comment.id, action: "comment"),
      create(:notification, visiter_id: other_user.id, visited_id: user.id, action: "follow")
    ]
  end

  before do
    sign_in user
  end

  describe '#index' do
    it "インスタンス変数の値が正常か" do
      get :index
      expect(assigns(:notifications)).to match(notifications)
    end

    it "ビューに正しく遷移できているか" do
      get :index
      expect(response).to render_template :index
    end

    it "checkedがfalseからtrueに更新されているか" do
      get :index
      assigns(:notifications).each do |notification|
        expect(notification.checked).to match(true)
      end
    end

    context '自分で自分にアクションを行った場合' do
      it "自分で自分にフォローを行った場合テーブルの件数が増えない" do
        expect do
          create(:relationship, user_id: user.id, follow_id: user.id)
        end.to_not change(Notification, :count)
      end

      it "自分で自分の投稿にいいねを行った場合テーブルの件数が増えない" do
        expect do
          create(:like, user_id: user.id, post_id: test_post.id)
        end.to_not change(Notification, :count)
      end

      it "自分で自分の投稿にコメントを行った場合テーブルの件数が増えない" do
        expect do
          create(:comment, post_id: test_post.id, user_id: user.id)
        end.to_not change(Notification, :count)
      end

      it "自分で自分のコメントにいいねを行った場合テーブルの件数が増えない" do
        expect do
          create(:comment_like, user_id: user.id, comment_id: comment.id)
        end.to_not change(Notification, :count)
      end
    end
  end
end
