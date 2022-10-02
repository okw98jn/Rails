require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "registrations#new" do
    context "ログイン済みユーザーの場合" do
      it "トップページにリダイレクトされること" do
        sign_in user
        get new_user_registration_path
        expect(response).to redirect_to root_path
      end
    end

    context "ログインしていないユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        get new_user_registration_path
        expect(response).to be_successful
      end
    end
  end

  describe "registrations#edit" do
    context "ログイン済みユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        sign_in user
        get edit_user_registration_path
        expect(response).to be_successful
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログイン画面にリダイレクトされること" do
        get edit_user_registration_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "sessions#new" do
    context "ログイン済みユーザーの場合" do
      it "マイページにリダイレクトされること" do
        sign_in user
        get new_user_session_path
        expect(response).to redirect_to user_path(user.id)
      end
    end

    context "ログインしていないユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        get new_user_session_path
        expect(response).to be_successful
      end
    end
  end

  describe "password#new" do
    context "ログイン済みユーザーの場合" do
      it "トップページにリダイレクトされること" do
        sign_in user
        get new_user_password_path
        expect(response).to redirect_to root_path
      end
    end

    context "ログインしていないユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        get new_user_password_path
        expect(response).to be_successful
      end
    end
  end

  describe "#index" do
    context "ログイン済みユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        sign_in user
        get users_path
        expect(response).to be_successful
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログイン画面にリダイレクトされること" do
        get users_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#show" do
    context "ログイン済みユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        sign_in user
        get user_path(user.id)
        expect(response).to be_successful
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログイン画面にリダイレクトされること" do
        get user_path(user.id)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#unsubscribe" do
    let(:another_user) { FactoryBot.create(:user, email: "rails@example.com") }

    context "ログイン済みユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        sign_in user
        get unsubscribe_path(user.id)
        expect(response).to be_successful
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログイン画面にリダイレクトされること" do
        get unsubscribe_path(user.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "他のユーザーを操作しようとした場合" do
      it "マイページにリダイレクトされること" do
        sign_in another_user
        get unsubscribe_path(user.id)
        expect(response).to redirect_to user_path(another_user.id)
      end
    end
  end
end
