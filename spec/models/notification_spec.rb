require 'rails_helper'

describe Notification, type: :model do
  describe '#create' do
    before do
      @user = create(:user)
      @other_user = create(:user)
      @test_post = create(:post, user_id: @user.id)
      @comment = create(:comment, post_id: @test_post.id, user_id: @user.id)
    end

    context 'can save' do
      it "action likeで登録できる" do
        notification = build(:notification, visiter_id: @user.id, visited_id: @other_user.id, post_id: @test_post, action: "like")
        expect(notification).to be_valid
      end

      it "action followで登録できる" do
        notification = build(:notification, visiter_id: @user.id, visited_id: @other_user.id, action: "follow")
        expect(notification).to be_valid
      end

      it "action commentで登録できる" do
        notification = build(:notification, visiter_id: @user.id, visited_id: @other_user.id, comment_id: @comment, action: "comment")
        expect(notification).to be_valid
      end
    end

    context 'can not save' do
      it "actionが無いためエラーになる" do
        notification = build(:notification, visiter_id: @user.id, visited_id: @other_user.id, post_id: @test_post, action: nil)
        notification.valid?
        expect(notification.errors[:action][0]).to include("を入力してください")
      end
    end
  end
end
