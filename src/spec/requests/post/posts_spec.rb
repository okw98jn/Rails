require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }

  describe "posts#new" do
    context "ログイン済みユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        sign_in user
        get new_post_path
        expect(response).to be_successful
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログインページにリダイレクトされること" do
        get new_post_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "posts#show" do
    context "ログイン済みユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        sign_in user
        get post_path(post.id)
        expect(response).to be_successful
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログインページにリダイレクトされること" do
        get post_path(post.id)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "posts#edit" do
    let(:another_user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post, user: user) }
    let(:another_post) { FactoryBot.create(:post, user: another_user) }

    context "自分の投稿の場合" do
      it "正常にレスポンスを返すこと" do
        sign_in user
        get edit_post_path(post.id)
        expect(response).to be_successful
      end
    end

    context "他人の投稿の場合" do
      it "マイページにリダイレクトされること" do
        sign_in user
        get edit_post_path(another_post.id)
        expect(response).to redirect_to user_path(user.id)
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログインページにリダイレクトされること" do
        get edit_post_path(post.id)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
