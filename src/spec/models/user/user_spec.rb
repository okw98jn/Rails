require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    let(:user) { FactoryBot.build(:user) }

    describe "name" do
      context "nameが入力されている場合" do
        it "有効となること" do
          user.name = "hoge"
          expect(user).to be_valid
        end
      end

      context "nameが入力されていない場合" do
        it "無効となること" do
          user.name = nil
          expect(user).to be_invalid
          expect(user.errors).to be_of_kind(:name, :blank)
        end
      end

      context "10文字以内の場合" do
        it "有効となること" do
          user.name = "a" * 10
          expect(user).to be_valid
        end
      end

      context "10文字以上の場合" do
        it "無効となること" do
          user.name = "a" * 11
          expect(user).to be_invalid
          expect(user.errors).to be_of_kind(:name, :too_long)
        end
      end
    end

    describe "email" do
      context "emailが入力されている場合" do
        it "有効となること" do
          user.email = "hoge@example.com"
          expect(user).to be_valid
        end
      end

      context "emailが入力されていない場合" do
        it "無効となること" do
          user.email = nil
          expect(user).to be_invalid
          expect(user.errors).to be_of_kind(:email, :blank)
        end
      end

      context "同じアドレスが登録されている場合" do
        it "無効となること" do
          FactoryBot.create(:user, email: "hoge@example.com")
          user.email = "hoge@example.com"
          expect(user).to be_invalid
          expect(user.errors).to be_of_kind(:email, :taken)
        end
      end

      context "メールアドレスの形式が正しくない場合" do
        it "無効となること" do
          user.email = "hoge@examplecom"
          expect(user).to be_invalid

          user.email = "hoge@example,com"
          expect(user).to be_invalid

          user.email = "hogeexample.com"
          expect(user).to be_invalid

          user.email = "hoge@example."
          expect(user).to be_invalid

          user.email = "@example.com"
          expect(user).to be_invalid
        end
      end
    end

    describe "password" do
      context "passwordが入力されている場合" do
        it "有効となること" do
          user.password = "password"
          expect(user).to be_valid
        end
      end

      context "passwordが入力されていない場合" do
        it "無効となること" do
          user.password = nil
          expect(user).to be_invalid
          expect(user.errors).to be_of_kind(:password, :blank)
        end
      end

      context "6文字以上の場合" do
        it "有効となること" do
          user.password = "a" * 6
          expect(user).to be_valid
        end
      end

      context "6文字以内の場合" do
        it "無効となること" do
          user.password = "a" * 5
          expect(user).to be_invalid
          expect(user.errors).to be_of_kind(:password, :too_short)
        end
      end

      context "パスワードと確認の値が一致する時" do
        it "有効となること" do
          user.password = "password"
          user.password_confirmation = "password"
          expect(user).to be_valid
        end
      end

      context "パスワードと確認の値が一致しない時" do
        it "無効となること" do
          user.password = "password"
          user.password_confirmation = "pass"
          expect(user).to be_invalid
          expect(user.errors).to be_of_kind(:password_confirmation, :confirmation)
        end
      end
    end
  end
end
