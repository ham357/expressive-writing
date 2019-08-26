require 'rails_helper'

describe PostDraft, type: :model do
  describe '#create' do
    before do
      @user = create(:user)
    end

    context 'can save' do
      it "すべてのデータがあり正常に登録できる" do
        post_draft = build(:post_draft, user_id: @user.id)
        expect(post_draft).to be_valid
      end

      it "contentsが無くても正常に登録できる" do
        post_draft = build(:post_draft, contents: nil, user_id: @user.id)
        post_draft.valid?
        expect(post_draft).to be_valid
      end

      it "imageが無くても正常に登録できる" do
        post_draft = build(:post_draft, image: nil, user_id: @user.id)
        expect(post_draft).to be_valid
      end

      it "contentsが999文字で登録できる" do
        post_draft = build(:post_draft, contents: ('a' * 999).to_s, user_id: @user.id)
        expect(post_draft).to be_valid
      end

      it "contentsが1000文字で登録できる" do
        post_draft = build(:post_draft, contents: ('a' * 1000).to_s, user_id: @user.id)
        expect(post_draft).to be_valid
      end

      it "titleが無くても正常に登録できる" do
        post_draft = build(:post_draft, title: nil, user_id: @user.id)
        expect(post_draft).to be_valid
      end

      it "titleが49文字で登録できる" do
        post_draft = build(:post_draft, title: ('a' * 49).to_s, user_id: @user.id)
        expect(post_draft).to be_valid
      end

      it "titleが50文字で登録できる" do
        post_draft = build(:post_draft, title: ('a' * 50).to_s, user_id: @user.id)
        expect(post_draft).to be_valid
      end
    end

    context 'can not save' do
      it "contentsが100文字より多いためエラーになる" do
        post_draft = build(:post_draft, contents: ('a' * 1001).to_s, user_id: @user.id)
        post_draft.valid?
        expect(post_draft.errors[:contents][0]).to include("は1000文字以内で入力してください")
      end

      it "titleが50文字より多いためエラーになる" do
        post_draft = build(:post_draft, title: ('a' * 51).to_s, user_id: @user.id)
        post_draft.valid?
        expect(post_draft.errors[:title][0]).to include("は50文字以内で入力してください")
      end
    end
  end
end
