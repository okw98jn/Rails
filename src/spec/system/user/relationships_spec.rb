require 'rails_helper'

RSpec.feature "Relationships", type: :system do
  background do
    sign_in user
  end
  feature "フォロー、フォロー解除機能", type: :system do
    given!(:user) { FactoryBot.create(:user) }
    given!(:another_user) { FactoryBot.create(:user) }
    context "他のユーザーをフォロー、フォロー解除しようとした場合" do
      scenario "フォロー、フォロー解除ができること" do
        visit user_path(another_user.id)
        click_link "フォローする"
        expect(another_user.followers.count).to eq(1)
        expect(user.followings.count).to eq(1)
        expect(page).to have_content "フォローを外す"
        click_link "フォローを外す"
        expect(another_user.followers.count).to eq(0)
        expect(user.followings.count).to eq(0)
        expect(page).to have_content "フォローする"
      end
    end

    context "自分をフォロー、フォロー解除しようとした場合" do
      scenario "フォロー、フォロー解除ができないこと" do
        visit user_path(user.id)
        expect(page).not_to have_link "フォローする"
        expect(page).not_to have_link "フォローを外す"
      end
    end
  end

  feature "フォロー一覧", type: :system do
    given!(:user) { FactoryBot.create(:user) }
    given!(:another_users) { FactoryBot.create_list(:user, 5) }
    context "フォローしているユーザーがいる場合" do
      background do
        another_users.each do |another_user|
          user.relationships.create(followed_id: another_user.id)
        end
      end
      scenario "ユーザーが表示されること" do
        visit user_followings_path(user.id)
        another_users[0..3].all? do |another_user|
          expect(page).to have_css ".user_block"
        end
      end
    end

    context "フォローしているユーザーがいない場合" do
      scenario "ユーザーが表示されないこと" do
        visit user_followings_path(user.id)
        expect(page).to have_content "ユーザーはいません"
      end
    end
  end

  feature "フォロワー一覧", type: :system do
    given!(:user) { FactoryBot.create(:user) }
    given!(:another_users) { FactoryBot.create_list(:user, 5) }
    context "フォロワーがいる場合" do
      background do
        another_users.each do |another_user|
          another_user.relationships.create(followed_id: user.id)
        end
      end
      scenario "ユーザーが表示されること" do
        visit user_followers_path(user.id)
        another_users[0..3].all? do |another_user|
          expect(page).to have_css ".user_block"
        end
      end
    end

    context "フォロワーがいない場合" do
      scenario "ユーザーが表示されないこと" do
        visit user_followers_path(user.id)
        expect(page).to have_content "ユーザーはいません"
      end
    end
  end
end
