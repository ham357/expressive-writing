require 'rails_helper'

describe Like, type: :model do
  describe '#create' do
    before do
      @user = create(:user)
      @test_post = create(:post)
    end

    context 'can save' do
      it "すべてのデータがあり正常に登録できる" do
        like = build(:like, post_id: @test_post.id, user_id: @user.id)
        expect(like).to be_valid
      end
    end

    context 'can not save' do
      it "post_idが無いためエラーになる" do
        like = build(:like, post_id: nil, user_id: @user.id)
        like.valid?
        expect(like.errors[:post]).to include("を入力してください")
      end

      it "post_idとuser_idが同じ組み合わせのためエラーになる" do
        like = create(:like, post_id: @test_post.id, user_id: @user.id)
        other_like = build(:like, post_id: @test_post.id, user_id: @user.id)
        other_like.valid?
        expect(other_like.errors[:post_id]).to include("はすでに存在します")
      end
    end
  end
end
