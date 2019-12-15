class CommentLike < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  validates_uniqueness_of :comment_id, scope: :user_id

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      visited: comment.user,
      comment: comment,
      post: comment.post,
      action: "comment_like"
    )
    notification.save if notification.valid?
  end
end
