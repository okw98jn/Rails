require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "#followings" do
    context "ログイン済みユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        sign_in user
        get user_followings_path(user.id)
        expect(response).to be_successful
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログイン画面にリダイレクトされること" do
        get user_followings_path(user.id)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#followers" do
    context "ログイン済みユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        sign_in user
        get user_followers_path(user.id)
        expect(response).to be_successful
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログイン画面にリダイレクトされること" do
        get user_followers_path(user.id)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
