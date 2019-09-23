require 'rails_helper'

describe Favorite, type: :model do
  describe '#create' do
    before do
      @user = create(:user)
      @test_post = create(:post)
    end

    context 'can save' do
      it "すべてのデータがあり正常に登録できる" do
        favorite = build(:favorite, post_id: @test_post.id, user_id: @user.id)
        expect(favorite).to be_valid
      end
    end

    context 'can not save' do
      it "post_idが無いためエラーになる" do
        favorite = build(:favorite, post_id: nil, user_id: @user.id)
        favorite.valid?
        expect(favorite.errors[:post]).to include("を入力してください")
      end

      it "post_idとuser_idが同じ組み合わせのためエラーになる" do
        create(:favorite, post_id: @test_post.id, user_id: @user.id)
        favorite = build(:favorite, post_id: @test_post.id, user_id: @user.id)
        favorite.valid?
        expect(favorite.errors[:post_id]).to include("はすでに存在します")
      end
    end
  end
end
