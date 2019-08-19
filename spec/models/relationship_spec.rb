require 'rails_helper'

describe Relationship, type: :model do
  describe '#create' do
    before do
      @user = create(:user)
      @other_user = create(:other_user)
    end

    context 'can save' do
      it "すべてのデータがあり正常に登録できる" do
        relationship = build(:relationship, user_id: @other_user.id, follow_id: @user.id)
        expect(relationship).to be_valid
      end
    end

    context 'can not save' do
      it "user_idが無いためエラーになる" do
        relationship = build(:relationship, user_id: nil, follow_id: @user.id)
        relationship.valid?
        expect(relationship.errors[:user]).to include("を入力してください")
      end

      it "follow_idが無いためエラーになる" do
        relationship = build(:relationship, user_id: @other_user, follow_id: nil)
        relationship.valid?
        expect(relationship.errors[:follow]).to include("を入力してください")
      end

      it "user_idとfollow_idが同じ組み合わせのためエラーになる" do
        create(:relationship, user_id: @other_user.id, follow_id: @user.id)
        relationship = build(:relationship, user_id: @other_user.id, follow_id: @user.id)
        relationship.valid?
        expect(relationship.errors[:user_id]).to include("はすでに存在します")
      end
    end
  end
end
