require 'rails_helper'

RSpec.feature "Favorites", type: :system do
  given(:user) { FactoryBot.create(:user) }
  given(:post) { FactoryBot.create(:post, user: user) }

  background do
    sign_in user
  end

  feature "#create #destroy", type: :system, js: true do
    scenario "投稿をいいね、いいね解除できること" do
      visit post_path(post.id)
      # いいねをするボタンを押す
      find('.like_btn').click
      expect(page).to have_selector '.nolike_btn'
      expect(post.favorites.count).to eq(1)
      # いいねを解除する
      find('.nolike_btn').click
      expect(page).to have_selector '.like_btn'
      expect(post.favorites.count).to eq(0)
    end
  end
end
