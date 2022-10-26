require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe "#create" do
    let(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post) }
    let(:another_user) { FactoryBot.create(:user) }
    let(:another_post) { FactoryBot.create(:post) }
    let(:favorite) { FactoryBot.build(:favorite, user_id: user.id, post_id: post.id) }
    let(:another_favorite) { FactoryBot.build(:favorite, user_id: another_user.id, post_id: another_post.id) }

    context "いいねできる場合" do
      it 'user_idとpost_idがあれば保存できる' do
        expect(favorite).to be_valid
      end

      it 'post_idが同じでもuser_idが違えばいいねできる' do
        favorite.user_id = another_favorite.user_id
        expect(favorite).to be_valid
      end

      it 'user_idが同じでもpost_idが違えばいいねできる' do
        favorite.post_id = another_favorite.post_id
        expect(favorite).to be_valid
      end
    end

    context "いいねできない場合" do
      it 'user_idがnilの場合はいいねできない' do
        favorite.user_id = nil
        expect(favorite).to be_invalid
        expect(favorite.errors).to be_of_kind(:user_id, :blank)
      end

      it 'post_idがnilの場合はいいねできない' do
        favorite.post_id = nil
        expect(favorite).to be_invalid
        expect(favorite.errors).to be_of_kind(:post_id, :blank)
      end

      it "同じ組み合わせのデータがある場合は保存できない" do
        favorite.save
        another_favorite.user_id = user.id
        another_favorite.post_id = post.id
        expect(another_favorite).to be_invalid
        expect(another_favorite.errors).to be_of_kind(:user_id, :taken)
      end
    end
  end
end
