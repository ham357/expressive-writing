require 'rails_helper'

describe PostsController, type: :controller do
  describe 'GET #index' do
    it "ビューに正しく遷移できる" do
      get :index
      expect(response).to render_template :index
    end
  end
end
