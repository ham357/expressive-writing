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
      expect(user.errors[:nickname]).to include("can't be blank")
    end

    it "21文字以上のニックネームでは保存不可 " do
      user = build(:user, nickname: "a" * 21)
      user.valid?
      expect(user.errors[:nickname][0]).to include("is too long")
    end

    it "20文字のニックネームでは保存可能" do
      user = build(:user, nickname: "a" * 20)
      expect(user).to be_valid
    end

    it "メールアドレスなしでは登録不可" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "パスワードなしでは登録不可" do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "パスワードとconfirmationの合致なしでは登録不可" do
      user = build(:user, password_confirmation: "")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it "メールアドレスの重複は登録不可" do
      user = create(:user)
      another_user = build(:user, email: user.email)
      another_user.valid?
      expect(another_user.errors[:email]).to include("has already been taken")
    end

    it "5文字以下のパスワードでは登録不可 " do
      user = build(:user, password: "0" * 5, password_confirmation: "0" * 5)
      user.valid?
      expect(user.errors[:password][0]).to include("is too short")
    end
  end
end
