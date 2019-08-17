require 'rails_helper'

describe CommentLike, type: :model do
  describe '#create' do
    before do
      @user = create(:user)
      @comment = create(:comment)
    end

    context 'can save' do
      it "すべてのデータがあり正常に登録できる" do
        comment_like = build(:comment_like, comment_id: @comment.id, user_id: @user.id)
        expect(comment_like).to be_valid
      end
    end

    context 'can not save' do
      it "comment_idが無いためエラーになる" do
        comment_like = build(:comment_like, comment_id: nil, user_id: @user.id)
        comment_like.valid?
        expect(comment_like.errors[:comment]).to include("を入力してください")
      end

      it "comment_idとuser_idが同じ組み合わせのためエラーになる" do
        create(:comment_like, comment_id: @comment.id, user_id: @user.id)
        comment_like = build(:comment_like, comment_id: @comment.id, user_id: @user.id)
        comment_like.valid?
        expect(comment_like.errors[:comment_id]).to include("はすでに存在します")
      end
    end
  end
end
