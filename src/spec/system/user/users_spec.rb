require 'rails_helper'

RSpec.feature "Users", type: :system do
  feature "新規登録", type: :system do
    given(:user) { FactoryBot.build(:user) }
    context "フォームに正しい値が入力されている場合" do
      scenario "登録できること" do
        visit new_user_registration_path
        fill_in "user[name]", with: user.name
        fill_in "user[email]", with: user.email
        fill_in "user[password]", with: user.password
        fill_in "user[password_confirmation]", with: user.password
        expect { click_button "登録" }.to change { User.count }.by(1)
        expect(page).to have_content "アカウント登録が完了しました"
      end
    end

    context "フォームに正しい値が入力されていない場合" do
      scenario "登録できないこと" do
        visit new_user_registration_path
        fill_in "user[name]", with: ""
        fill_in "user[email]", with: ""
        fill_in "user[password]", with: ""
        fill_in "user[password_confirmation]", with: ""
        expect { click_button "登録" }.to change { User.count }.by(0)
        expect(page).to have_content "名前を入力してください"
        expect(page).to have_content "メールアドレスを入力してください"
        expect(page).to have_content "パスワードを入力してください"
      end
    end
  end

  feature "ログイン", type: :system do
    given!(:user) { FactoryBot.create(:user) }
    given!(:canceled_user) { FactoryBot.create(:user, is_deleted: true) }

    context "フォームに正しい値が入力されている場合" do
      scenario "ログインできること" do
        visit new_user_session_path
        fill_in "user[email]", with: user.email
        fill_in "user[password]", with: user.password
        fill_in "user[password_confirmation]", with: user.password
        click_button "ログイン"
        expect(page).to have_content "ログインしました"
        expect(current_path).to eq user_path(user.id)
      end
    end

    context "フォームに正しい値が入力されていない場合" do
      scenario "ログインできないこと" do
        visit new_user_session_path
        fill_in "user[email]", with: ""
        fill_in "user[password]", with: ""
        fill_in "user[password_confirmation]", with: ""
        click_button "ログイン"
        expect(page).to have_content "メールアドレスまたはパスワードが違います"
        expect(current_path).to eq new_user_session_path
      end
    end

    context "退会済みのアカンウトでログインしようとした場合" do
      scenario "ログインできないこと" do
        visit new_user_session_path
        fill_in "user[email]", with: canceled_user.email
        fill_in "user[password]", with: canceled_user.password
        fill_in "user[password_confirmation]", with: canceled_user.password
        click_button "ログイン"
        expect(page).to have_content "退会したアカウントです。新規登録をしてください"
        expect(current_path).to eq new_user_session_path
      end
    end

    context "ゲストユーザーとしてログインしようとした場合" do
      scenario "ログインできること" do
        visit new_user_session_path
        click_link "ゲストログイン"
        expect(page).to have_content "ゲストユーザーとしてログインしました。"
      end
    end
  end

  feature "マイページ", type: :system do
    given!(:user) { FactoryBot.create(:user) }
    given!(:another_user) { FactoryBot.create(:user) }
    background do
      sign_in user
    end
    context "自分のマイページの場合" do
      scenario "作成、編集、退会が表示される" do
        visit user_path(user.id)
        expect(page).to have_link "作成"
        expect(page).to have_link "編集"
        expect(page).to have_link "退会する"
      end
    end

    context "他のユーザーのマイページの場合" do
      scenario "作成、編集、退会が表示されない" do
        visit user_path(another_user.id)
        expect(page).not_to have_link "作成"
        expect(page).not_to have_link "編集"
        expect(page).not_to have_link "退会する"
      end
    end
  end

  feature "アカウント編集", type: :system do
    given!(:user) { FactoryBot.create(:user) }
    background do
      sign_in user
    end
    context "フォームに正しい値が入力されている場合" do
      scenario "更新できること" do
        visit edit_user_registration_path
        expect(page).to have_field "user[name]", with: user.name
        expect(page).to have_field "user[email]", with: user.email
        fill_in "user[introduction]", with: "初めまして。hogeです。"
        click_button "変更する"
        expect(page).to have_content "アカウント情報を変更しました"
        expect(page).to have_content user.name
        expect(page).to have_content "初めまして。hogeです。"
      end
    end

    context "フォームに正しい値が入力されていない場合" do
      scenario "更新できないこと" do
        visit edit_user_registration_path
        expect(page).to have_field "user[name]", with: user.name
        expect(page).to have_field "user[email]", with: user.email
        fill_in "user[name]", with: ""
        fill_in "user[email]", with: ""
        click_button "変更する"
        expect(page).to have_content "名前を入力してください"
        expect(page).to have_content "メールアドレスを入力してください"
      end
    end
  end

  feature "退会", type: :system do
    given!(:user) { FactoryBot.create(:user) }
    background do
      sign_in user
    end
    context "退会する場合" do
      scenario "退会できること" do
        visit unsubscribe_path(user.id)
        click_link "退会する"
        expect(page).to have_content "退会処理を実行しました"
        expect(current_path).to eq root_path
      end
    end

    context "退会しない場合" do
      scenario "マイページに遷移すること" do
        visit unsubscribe_path(user.id)
        click_link "退会しない"
        expect(current_path).to eq user_path(user.id)
      end
    end
  end

  feature "ユーザー一覧", type: :system do
    given!(:user) { FactoryBot.create(:user) }
    background do
      sign_in user
    end
    context "他のユーザーがいる場合" do
      given!(:another_users) { FactoryBot.create_list(:user, 5) }
      scenario "ユーザーが4名表示されること" do
        visit users_path
        another_users[0..3].all? do |another_user|
          expect(page).to have_css '.user_block'
        end
      end
      scenario "自分は表示されないこと" do
        visit users_path
        expect(page).not_to have_content user.name
      end
    end

    context "他のユーザーがいない場合" do
      scenario "ユーザーが表示されないこと" do
        visit users_path
        expect(page).to have_content "ユーザーはいません"
      end
    end
  end
end
