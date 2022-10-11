class Procedure < ApplicationRecord
  belongs_to :post

  mount_uploader :process_image, ImageUploader
end
