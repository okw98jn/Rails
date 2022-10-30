require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "#create" do
    let(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post) }
    let(:comment) { FactoryBot.build(:comment, user_id: user.id, post_id: post.id) }

    context "コメントできる場合" do
      it "コメント文を入力済みであれば保存できる" do
        expect(comment).to be_valid
      end
    end

    context "コメントできない場合" do
      it "コメント文が空白の場合は保存できない" do
        comment.body = ""
        expect(comment).to be_invalid
        expect(comment.errors).to be_of_kind(:body, :blank)
      end

      it "user_idがnilの場合は保存できない" do
        comment.user_id = nil
        expect(comment).to be_invalid
      end

      it "post_idがnilの場合は保存できない" do
        comment.post_id = nil
        expect(comment).to be_invalid
      end
    end
  end
end
