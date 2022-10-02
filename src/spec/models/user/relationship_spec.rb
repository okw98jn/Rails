require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe '#create' do
    let(:user) { FactoryBot.create(:user) }
    let(:another_user) { FactoryBot.create(:user) }
    let(:relationship) { user.follow(another_user.id) }
    let(:another_relationship) { user.follow(another_user.id) }

    context '保存できる場合' do
      it '全てのパラメーターが揃っていれば保存できる' do
        expect(relationship).to be_valid
      end
    end

    context "保存できない場合" do
      it "follower_idがnilの場合は保存できない" do
        relationship.follower_id = nil
        expect(relationship).to be_invalid
        expect(relationship.errors).to be_of_kind(:follower_id, :blank)
      end

      it "followed_idがnilの場合は保存できない" do
        relationship.followed_id = nil
        expect(relationship).to be_invalid
        expect(relationship.errors).to be_of_kind(:followed_id, :blank)
      end

      it "同じ組み合わせのデータがある場合は保存できない" do
        relationship.save
        expect(another_relationship).to be_invalid
        expect(another_relationship.errors).to be_of_kind(:follower_id, :taken)
      end
    end
  end
end
