require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "#index" do
    context "ログイン済みユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        sign_in user
        get notifications_path
        expect(response).to be_successful
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログイン画面にリダイレクトされること" do
        get notifications_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
