require 'rails_helper'

RSpec.feature "notifications", type: :system do
  given(:user) { FactoryBot.create(:user) }
  given(:another_user) { FactoryBot.create(:user) }
  given(:post) { FactoryBot.create(:post, user: user) }

  feature "#create", type: :system, js: true do
    context "フォローされた場合" do
      scenario "通知されること" do
        sign_in another_user
        visit user_path(user.id)
        click_link "フォローする"
        expect(user.passive_notifications.count).to eq(1)
        sign_in user
        visit notifications_path
        expect(page).to have_content "#{another_user.name}さんがあなたをフォローしました"
      end
    end

    context "いいねされた場合" do
      scenario "通知されること" do
        sign_in another_user
        visit post_path(post.id)
        find('.like_btn').click
        expect(page).to have_selector '.nolike_btn'
        sign_in user
        visit notifications_path
        expect(page).to have_content "#{another_user.name}さんがあなたの投稿にいいねしました"
      end
    end

    context "コメントされた場合" do
      scenario "通知されること" do
        sign_in another_user
        visit post_path(post.id)
        find('.comment_btn').click
        fill_in "comment[body]", with: "美味しそうなご飯ですね"
        click_button "コメント"
        sign_in user
        visit notifications_path
        expect(page).to have_content "#{another_user.name}さんがあなたの投稿にコメントしました"
        expect(page).to have_content "美味しそうなご飯ですね"
      end
    end
  end

  feature "#destroy", type: :system do
    scenario "通知を全削除できること" do
      sign_in another_user
      visit user_path(user.id)
      click_link "フォローする"
      expect(user.passive_notifications.count).to eq(1)
      sign_in user
      visit notifications_path
      expect(page).to have_content "#{another_user.name}さんがあなたをフォローしました"
      click_link "全削除"
      expect(page).to have_content "通知はありません"
    end
  end
end
