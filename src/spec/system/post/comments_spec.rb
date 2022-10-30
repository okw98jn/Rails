require 'rails_helper'

RSpec.feature "Favorites", type: :system do
  given(:user) { FactoryBot.create(:user) }
  given(:post) { FactoryBot.create(:post, user: user) }
  given(:another_user) { FactoryBot.create(:user) }
  given(:another_post) { FactoryBot.create(:post, user: another_user) }
  given!(:comment) { FactoryBot.create(:comment, user_id: user.id, post_id: post.id) }
  given!(:another_comment) { FactoryBot.create(:comment, user_id: another_user.id, post_id: another_post.id) }

  background do
    sign_in user
  end

  feature "#create", type: :system, js: true do
    context "フォームにコメントが入力されている場合" do
      scenario "コメントできること" do
        visit post_path(post)
        find('.comment_btn').click
        fill_in "comment[body]", with: "美味しそうなご飯ですね"
        expect { click_button "コメント" }.to change { Comment.count }.by(1)
        expect(page).to have_content "コメントしました"
      end
    end

    context "フォームにコメントが入力されていない場合" do
      scenario "コメントできないこと" do
        visit post_path(post)
        find('.comment_btn').click
        fill_in "comment[body]", with: ""
        expect { click_button "コメント" }.to change { Comment.count }.by(0)
      end
    end

    scenario "コメントが表示されていること" do
      visit post_path(post)
      expect(page).to have_content comment.body
      expect(page).to have_content comment.user.name
    end
  end

  feature "#edit", type: :system do
    context "自分のコメントの場合" do
      scenario "編集できること" do
        visit post_path(post)
        find('.comment_edit_icon').click
        expect(current_path).to eq edit_post_comment_path(post, comment)
        fill_in "comment[body]", with: "コメントを変更しました"
        click_button "編集する"
        expect(page).to have_content "コメントを編集しました"
        expect(page).to have_content "コメントを変更しました"
      end
    end

    context "他人のコメントの場合" do
      scenario "編集アイコンが表示されないこと" do
        visit post_path(another_post)
        expect(page).not_to have_selector '.comment_edit_icon'
      end
    end
  end

  feature "#destroy", type: :system do
    context "自分のコメントの場合" do
      scenario "削除できること" do
        visit post_path(post)
        find('.comment_delete_icon').click
        expect(page).to have_content "コメントを削除しました"
      end
    end

    context "他人のコメントの場合" do
      scenario "削除アイコンが表示されないこと" do
        visit post_path(another_post)
        expect(page).not_to have_selector '.comment_delete_icon'
      end
    end
  end
end
