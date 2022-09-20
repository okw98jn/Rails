class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable

  # ゲストユーザーメソッド
  def self.guest
    find_or_create_by!(email: 'aaa@aaa.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.password_confirmation = user.password
      user.name = 'ゲストさん'
    end
  end

  # パスワード無しで編集できるようにするメソッド
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  # 退会したユーザーがログイン出来ないようにする
  def active_for_authentication?
    super && (is_deleted == false)
  end

  validates :name, presence: true, length: { maximum: 10, allow_blank: true }
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, allow_blank: true }
  validates :password, presence: true, length: { minimum: 6, allow_blank: true }, confirmation: true, on: :create
end
