module NotificationsHelper
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end

  def notification_form(notification)
    @comment = nil
    visiter = link_to notification.user.nickname, notification.user, style: "font-weight: bold;"
    your_post = link_to 'あなたの投稿', notification.post, style: "font-weight: bold;", remote: true
    case notification.action
    when "follow"
      "#{visiter}があなたをフォローしました"
    when "like"
      "#{visiter}が#{your_post}にいいね！しました"
    when "comment" then
      @comment = Comment.find_by(id: notification.comment_id)&.comment
      "#{visiter}が#{your_post}にコメントしました"
    when "comment_like" then
      your_post = link_to 'この記事', notification.post, style: "font-weight: bold;"
      @comment = Comment.find_by(id: notification.comment_id)&.comment
      "#{visiter}が#{your_post}のあなたのコメントにいいね！しました"
    end
  end
end
