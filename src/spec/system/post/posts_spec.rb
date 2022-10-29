require 'rails_helper'

RSpec.feature "Posts", type: :system do
  given(:user) { FactoryBot.create(:user) }
  given(:post) { FactoryBot.create(:post, user: user) }
  given(:another_user) { FactoryBot.create(:user) }
  given(:another_post) { FactoryBot.create(:post, user: another_user) }
  given!(:category_1) { FactoryBot.create(:category, name: 'お肉料理') }
  given!(:category_2) { FactoryBot.create(:category, name: '野菜料理') }

  background do
    sign_in user
  end

  feature "レシピ投稿", type: :system, js: true do
    context "フォームにレシピ名と画像が入力されている場合" do
      scenario "投稿できること" do
        visit new_post_path
        fill_in "post[title]", with: post.title
        select('お肉料理', from: 'post_category_id')
        attach_file "post[post_image]", "#{Rails.root}/spec/fixtures/test.jpg", make_visible: true
        expect { click_button "完了する" }.to change { Post.count }.by(1)
        expect(page).to have_content "投稿が完了しました"
      end
    end

    context "フォームにレシピ名と画像が入力されていない場合" do
      scenario "投稿できないこと" do
        visit new_post_path
        expect { click_button "完了する" }.to change { Post.count }.by(0)
        expect(page).to have_content "料理名を入力してください"
        expect(page).to have_content "写真を入力してください"
      end
    end
  end

  feature "レシピ詳細ページ", type: :system do
    scenario "レシピの情報が表示されること" do
      visit post_path(post.id)
      expect(page).to have_content post.title
      expect(page).to have_content post.description
      expect(page).to have_content post.time
      expect(page).to have_content post.category.name
      expect(page).to have_selector("img[src$='test.jpg']")
    end

    context "自分の投稿の場合" do
      scenario "編集、削除アイコンが表示されること" do
        visit post_path(post.id)
        expect(page).to have_selector(".post_links")
      end
    end

    context "他人の投稿の場合" do
      scenario "編集、削除アイコンが表示されないこと" do
        visit post_path(another_post.id)
        expect(page).not_to have_selector(".post_links")
      end
    end
  end

  feature "レシピ編集", type: :system, js: true do
    context "フォームにレシピ名と画像が入力されている場合" do
      scenario "編集できること" do
        visit edit_post_path(post.id)
        expect(page).to have_field "post[title]", with: post.title
        expect(page).to have_selector("img[src$='test.jpg']")
        fill_in "post[title]", with: "ラーメン"
        fill_in "post[description]", with: "美味しいラーメンです"
        select('野菜料理', from: 'post_category_id')
        click_button "完了する"
        expect(page).to have_content "投稿を編集しました"
        expect(page).to have_content "ラーメン"
        expect(page).to have_content "野菜料理"
        expect(page).to have_content "美味しいラーメンです"
        expect(current_path).to eq post_path(post.id)
      end
    end

    context "フォームにレシピ名と画像が入力されていない場合" do
      scenario "編集できないこと" do
        visit edit_post_path(post.id)
        expect(page).to have_field "post[title]", with: post.title
        expect(page).to have_selector("img[src$='test.jpg']")
        fill_in "post[title]", with: ""
        fill_in "post[description]", with: "美味しいラーメンです"
        click_button "完了する"
        expect(page).to have_content "料理名を入力してください"
      end
    end
  end

  feature "レシピ削除", type: :system do
    scenario "削除できること" do
      visit post_path(post.id)
      find('.delete_icon').click
      expect(page).to have_content "投稿を削除しました"
      expect(current_path).to eq user_path(user.id)
    end
  end
end
