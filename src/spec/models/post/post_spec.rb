require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "バリデーション" do
    let(:user) { FactoryBot.build(:user) }
    let(:post) { FactoryBot.build(:post, user: user) }

    describe "title" do
      context "titleが入力されている場合" do
        it "有効となること" do
          post.title = "hoge"
          expect(post).to be_valid
        end
      end

      context "titleが入力されていない場合" do
        it "無効となること" do
          post.title = ""
          expect(post).to be_invalid
          expect(post.errors).to be_of_kind(:title, :blank)
        end
      end

      context "30文字以内の場合" do
        it "有効となること" do
          post.title = "a" * 30
          expect(post).to be_valid
        end
      end

      context "30文字以上の場合" do
        it "無効となること" do
          post.title = "a" * 31
          expect(post).to be_invalid
          expect(post.errors).to be_of_kind(:title, :too_long)
        end
      end
    end

    describe "post_image" do
      context "post_imageが入力されている場合" do
        it "有効となること" do
          post.post_image = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg'))
          expect(post).to be_valid
        end
      end

      context "post_imageが入力されていない場合" do
        it "無効となること" do
          post.post_image = ""
          expect(post).to be_invalid
          expect(post.errors).to be_of_kind(:post_image, :blank)
        end
      end
    end
  end
end
