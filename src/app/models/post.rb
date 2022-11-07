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
  # カテゴリー
  belongs_to :category

  # コメント
  has_many :comments, dependent: :destroy

  # 通知
  has_many :notifications, dependent: :destroy

  mount_uploader :post_image, ImageUploader
  validates :title, presence: true, length: { maximum: 30, allow_blank: true }
  validates :post_image, presence: true

  # いいねしているか判定
  def favorited?(user)
    favorites.exists?(user_id: user.id)
  end

  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  def self.search(search)
    if search
      Post.includes(:materials).where(['title LIKE ? OR material_name LIKE ? ', "%#{search}%", "%#{search}%"]).references(:materials)
    end
  end
end
