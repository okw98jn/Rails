class Post < ApplicationRecord
  belongs_to :user
  has_many :materials, dependent: :destroy
  accepts_nested_attributes_for :materials, allow_destroy: true

  mount_uploader :post_image, ImageUploader
  validates :title, presence: true, length: { maximum: 30, allow_blank: true }
  validates :post_image, presence: true
end
