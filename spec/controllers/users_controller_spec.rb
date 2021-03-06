require 'rails_helper'

describe UsersController, type: :controller do
  describe '#index' do
    let(:users) do
      [
        create(:user, nickname: "山田太郎"),
        create(:user, nickname: "山田二郎"),
        create(:user, nickname: "鈴木二郎")
      ]
    end

    before do
      sign_in users[0]
    end

    it "インスタンス変数の値が正常か" do
      keyword_users = User.where('nickname LIKE(?)', "山田%").order('nickname')
      get :index, params: { keyword: "山田" }
      expect(assigns(:users)).to match(keyword_users)
    end

    it "ビューに正しく遷移できているか" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe '#show' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    context 'viewが表示できているか' do
      it 'showのテンプレートが表示されてるか' do
        get :show, params: { id: user.id }
        expect(response).to render_template :show
      end
      it '投稿内容が正常に表示できているか' do
        get :show, params: { id: user.id }
        expect(assigns(:user).comment).to eq "プロフィールコメントです。"
      end
    end
  end

  describe '#update' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    context 'パラメータが妥当な場合' do
      it "投稿内容が更新できているか" do
        patch :update, params: { user: { comment: "変更しました" },
                                 id: user.id  }
        user.reload
        expect(user.comment).to eq("変更しました")
      end

      it "正常にプロフィールページへリダイレクトされているか" do
        patch :update, params: { user: { comment: "変更しました" },
                                 id: user.id  }
        user.reload
        expect(response).to redirect_to user_path(user.id)
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        patch :update, params: { user: { comment: "変更しました" },
                                 id: user.id  }
        expect(response.status).to eq 302
      end

      it '投稿内容が変更されないこと' do
        expect do
          put :update, params: { user: { comment: "変更しました" },
                                 id: user.id  }
        end.to_not change(User.find(user.id), :comment)
      end
    end
  end
end
