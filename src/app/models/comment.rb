class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # 通知
  has_many :notifications, dependent: :destroy

  validates :body, presence: true
end
