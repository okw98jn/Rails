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

  feature "#create", type: :system, js: true do
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

  feature "#show", type: :system do
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

  feature "#update", type: :system, js: true do
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

  feature "#search", type: :system do
    given!(:post) { FactoryBot.create(:post, user: user, title: "ラーメン") }

    background do
      visit posts_path
    end

    context "検索にヒットした場合" do
      scenario "ヒットした投稿が表示されること" do
        fill_in "keyword", with: "ラーメン"
        find('.rspec_search_btn').click
        expect(page).to have_content "ラーメンの検索結果(1件)"
        expect(page).to have_content "ラーメン"
      end
    end

    context "検索にヒットしなかった場合" do
      scenario "表示されないこと" do
        fill_in "keyword", with: "カレー"
        find('.rspec_search_btn').click
        expect(page).to have_content "カレーの検索結果(0件)"
      end
    end

    context "検索フォームが空白の場合" do
      scenario "投稿一覧ページにリダイレクトされること" do
        fill_in "keyword", with: ""
        expect(current_path).to eq posts_path
        expect(page).to have_content "全ての投稿"
      end
    end
  end

  feature "#search_category", type: :system, js: true do
    given!(:post) { FactoryBot.create(:post, user: user, title: "牛丼", category: category_1) }
    given!(:category_1) { FactoryBot.create(:category, name: 'お肉料理') }
    given!(:category_2) { FactoryBot.create(:category, name: '野菜料理') }

    background do
      visit posts_path
    end

    scenario "カテゴリボタンを押すとメニューが出てくること" do
      expect(page).not_to have_selector '.search_category_area'
      find('.rspec_category_btn').click
      expect(page).to have_selector '.search_category_area'
    end

    context "選択したカテゴリに投稿がある場合" do
      scenario "投稿が表示されること" do
        find('.rspec_category_btn').click
        within '.search_category_area' do
          click_link "お肉料理"
        end
        expect(current_path).to eq search_category_post_path(category_1)
        expect(page).to have_content "お肉料理の検索結果(1件)"
        expect(page).to have_content "牛丼"
      end
    end

    context "選択したカテゴリに投稿がない場合" do
      scenario "投稿が表示されないこと" do
        find('.rspec_category_btn').click
        within '.search_category_area' do
          click_link "野菜料理"
        end
        expect(current_path).to eq search_category_post_path(category_2)
        expect(page).to have_content "野菜料理の検索結果(0件)"
      end
    end
  end

  feature "#post_favorite_rank", type: :system do
    given!(:post) { FactoryBot.create(:post, user: user, title: "牛丼") }
    given!(:not_favorite_post) { FactoryBot.create(:post, user: user, title: "ラーメン") }
    given!(:favorite) { FactoryBot.create(:favorite, post: post) }

    background do
      visit posts_path
      click_link "いいねが多い順"
      expect(current_path).to eq post_favorite_rank_posts_path
    end

    scenario "検索タイトルが表示されること" do
      expect(page).to have_content "いいねランキング"
    end

    scenario "いいねが多い順に投稿が表示されること" do
      expect(page.text).to match(/#{post.title}[\s\S]*#{not_favorite_post.title}/)
      expect(page.text).not_to match(/#{not_favorite_post.title}[\s\S]*#{post.title}/)
    end
  end

  feature "#post_comment_rank", type: :system do
    given!(:post) { FactoryBot.create(:post, user: user, title: "牛丼") }
    given!(:not_comment_post) { FactoryBot.create(:post, user: user, title: "ラーメン") }
    given!(:comment) { FactoryBot.create(:comment, post: post) }

    background do
      visit posts_path
      click_link "コメントが多い順"
      expect(current_path).to eq post_comment_rank_posts_path
    end

    scenario "検索タイトルが表示されること" do
      expect(page).to have_content "コメントランキング"
    end

    scenario "コメントが多い順に投稿が表示されること" do
      expect(page.text).to match(/#{post.title}[\s\S]*#{not_comment_post.title}/)
      expect(page.text).not_to match(/#{not_comment_post.title}[\s\S]*#{post.title}/)
    end
  end

  feature "#destroy", type: :system do
    scenario "削除できること" do
      visit post_path(post.id)
      find('.delete_icon').click
      expect(page).to have_content "投稿を削除しました"
      expect(current_path).to eq user_path(user.id)
    end
  end
end
