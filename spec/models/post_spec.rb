require 'rails_helper'

describe Post, type: :model do
  describe '#create' do
    before do
      @user = create(:user)
    end

    context 'can save' do
      it "すべてのデータがあり正常に登録できる" do
        post = build(:post, user_id: @user.id)
        expect(post).to be_valid
      end

      it "imageが無くても正常に登録できる" do
        post = build(:post, image: nil, user_id: @user.id)
        expect(post).to be_valid
      end

      it "contentsが999文字で登録できる" do
        post = build(:post, contents: ('a' * 999).to_s, user_id: @user.id)
        expect(post).to be_valid
      end

      it "contentsが1000文字で登録できる" do
        post = build(:post, contents: ('a' * 1000).to_s, user_id: @user.id)
        expect(post).to be_valid
      end
    end

    context 'can not save' do
      it "contentsが無いためエラーになる" do
        post = build(:post, contents: nil, user_id: @user.id)
        post.valid?
        expect(post.errors[:contents]).to include("can't be blank")
      end

      it "説明文が100文字より多いためエラーになる" do
        post = build(:post, contents: ('a' * 1001).to_s, user_id: @user.id)
        post.valid?
        expect(post.errors[:contents][0]).to include("is too long")
      end
    end
  end
end
