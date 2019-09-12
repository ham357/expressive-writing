require 'rails_helper'

describe RelationshipsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  before do
    sign_in user
  end

  describe '#create' do
    context 'パラメータが妥当な場合' do
      it "フォローの保存ができているか" do
        expect do
          post :create, params: {
            relationship: {
              follow_id: other_user.id
            }
          }
        end.to change(Relationship, :count).by(1)
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post :create, params: {
          relationship: {
            follow_id: other_user.id
          }
        }
        expect(response.status).to eq 200
      end

      it 'フォローの保存がされないこと' do
        create(:relationship, user_id: user.id, follow_id: other_user.id)
        expect do
          post :create, params: {
            relationship: {
              follow_id: other_user.id
            }
          }
        end.to_not change(Relationship, :count)
      end
    end
  end

  describe '#destroy' do
    it "フォローが削除されているか" do
      relationship = create(:relationship, user_id: user.id, follow_id: other_user.id)

      expect do
        delete :destroy, params: {
          id: relationship.id,
          relationship: {
            follow_id: other_user.id
          }
        }
      end.to change(Relationship, :count).by(-1)
    end
  end
end
