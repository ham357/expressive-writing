require 'rails_helper'

describe User do
  describe '#create' do
    it "すべてのデータがあり、正常に登録できる" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "ニックネームなしでは保存不可" do
      user = build(:user, nickname: nil)
      user.valid?
      expect(user.errors[:nickname]).to include("が入力されていません。")
    end

    it "21文字以上のニックネームでは保存不可 " do
      user = build(:user, nickname: "a" * 21)
      user.valid?
      expect(user.errors[:nickname][0]).to include("は20文字以下に設定して下さい。")
    end

    it "20文字のニックネームでは保存可能" do
      user = build(:user, nickname: "a" * 20)
      expect(user).to be_valid
    end

    it "メールアドレスなしでは登録不可" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("が入力されていません。")
    end

    it "パスワードなしでは登録不可" do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("が入力されていません。")
    end

    it "パスワードとconfirmationの合致なしでは登録不可" do
      user = build(:user, password_confirmation: "")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("が内容とあっていません。")
    end

    it "メールアドレスの重複は登録不可" do
      user = create(:user)
      another_user = build(:user, email: user.email)
      another_user.valid?
      expect(another_user.errors[:email]).to include("は既に使用されています。")
    end

    it "5文字以下のパスワードでは登録不可 " do
      user = build(:user, password: "0" * 5, password_confirmation: "0" * 5)
      user.valid?
      expect(user.errors[:password][0]).to include("は6文字以上に設定して下さい。")
    end

    it "201文字以上のコメントでは保存不可 " do
      user = build(:user, comment: "a" * 201)
      user.valid?
      expect(user.errors[:comment][0]).to include("200文字以内で入力してください")
    end

    it "200文字のコメントでは保存可能" do
      user = build(:user, comment: "a" * 200)
      expect(user).to be_valid
    end
  end
end
