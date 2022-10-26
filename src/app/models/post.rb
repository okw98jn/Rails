class Post < ApplicationRecord
  belongs_to :user
  # 材料
  has_many :materials, dependent: :destroy
  # 作り方
  has_many :procedures, dependent: :destroy
  # ネストしたフォーム用
  accepts_nested_attributes_for :materials, :procedures, allow_destroy: true
  # いいね
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user

  mount_uploader :post_image, ImageUploader
  validates :title, presence: true, length: { maximum: 30, allow_blank: true }
  validates :post_image, presence: true

  # いいねしているか判定
  def favorited?(user)
    favorites.exists?(user_id: user.id)
  end
end
