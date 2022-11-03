module NotificationsHelper
  def notification_form(notification)
    visitor = notification.visitor
    visited = notification.visited
    case notification.action
    when 'follow'
      tag.a(notification.visitor.name, href: user_path(visitor)) + 'さんがあなたをフォローしました'
    when 'like'
      tag.a(notification.visitor.name, href: user_path(visitor)) + 'さんが' + tag.a('あなたの投稿', href: post_path(notification.post_id)) + 'にいいねしました'
    when 'comment' then
      if notification.post.user_id == visited.id
        tag.a(visitor.name, href: user_path(visitor)) + 'さんが' + tag.a("あなたの投稿", href: post_path(notification.post_id)) + 'にコメントしました'
      else
        tag.a(visitor.name, href: user_path(visitor)) + 'さんが' + tag.a(image_tag(notification.post.user.user_image.url) + notification.post.user.name + 'さんのレシピ', href: post_path(notification.post_id), class: 'second_user') + 'にコメントしました'
      end
    end
  end

  def unchecked_notifications
    notifications = current_user.passive_notifications.where(checked: false)
  end
end
