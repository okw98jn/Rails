class Post < ApplicationRecord
  belongs_to :user
  mount_uploader :post_image, ImageUploader
  validates :title, presence: true, length: { maximum: 30, allow_blank: true }
  validates :post_image, presence: true
end
