class Comment < ApplicationRecord
  validates :comment, length: { maximum: 250 }
  validates :comment, presence: true

  belongs_to :post
  belongs_to :user
  has_many :comment_likes, dependent: :destroy
  has_many :liking_users, through: :comment_likes, source: :user
  has_many :notifications, dependent: :destroy

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      comment: self,
      visited: post.user,
      post: post,
      action: "comment"
    )
    notification.save if notification.valid?
  end
end
