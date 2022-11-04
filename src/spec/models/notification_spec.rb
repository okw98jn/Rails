require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "#create" do
    let(:user) { FactoryBot.create(:user) }
    let(:another_user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post) }
    let(:comment) { FactoryBot.build(:comment, user_id: user.id, post_id: post.id) }

    context "投稿関連の通知" do
      it "いいねされた場合に保存できる" do
        notification = FactoryBot.build(:notification, post_id: post.id, visited_id: user.id, visitor_id: user.id, action: "like")
        expect(notification).to be_valid
      end

      it "コメントされた場合に保存できる" do
        notification = FactoryBot.build(:notification, post_id: post.id, comment_id: comment.id, visited_id: user.id, visitor_id: user.id, action: "comment")
        expect(notification).to be_valid
      end
    end

    context "フォロー関連の通知" do
      it "フォローされた場合に保存できる" do
        notification = FactoryBot.build(:notification, visited_id: user.id, visitor_id: another_user.id, action: "follow")
        expect(notification).to be_valid
      end
    end
  end
end
