require 'rails_helper'

describe Comment, type: :model do
  describe '#create' do
    before do
      @user = create(:user)
      @test_post = create(:post)
    end

    context 'can save' do
      it "すべてのデータがあり正常に登録できる" do
        comment = build(:comment, post_id: @test_post.id, user_id: @user.id)
        expect(comment).to be_valid
      end

      it "commentが249文字で登録できる" do
        comment = build(:comment, comment: ('a' * 249).to_s, post_id: @test_post.id, user_id: @user.id)
        expect(comment).to be_valid
      end

      it "commentが250文字で登録できる" do
        comment = build(:comment, comment: ('a' * 250).to_s, post_id: @test_post.id, user_id: @user.id)
        expect(comment).to be_valid
      end
    end

    context 'can not save' do
      it "commentが無いためエラーになる" do
        comment = build(:comment, comment: nil, post_id: @test_post.id, user_id: @user.id)
        comment.valid?
        expect(comment.errors[:comment]).to include("が入力されていません。")
      end

      it "commentが250文字より多いためエラーになる" do
        comment = build(:comment, comment: ('a' * 251).to_s, post_id: @test_post.id, user_id: @user.id)
        comment.valid?
        expect(comment.errors[:comment][0]).to include("は250文字以下に設定して下さい。")
      end
    end
  end
end
