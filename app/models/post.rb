class Post < ApplicationRecord
  validates :title, length: { maximum: 50 }
  validates :contents, length: { maximum: 1000 }
  validates :contents, presence: true
  mount_uploader :image, ImageUploader

  belongs_to :user
  has_many   :comments
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  has_many :notifications, dependent: :destroy

  paginates_per 20

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      post_id: id,
      visited_id: user.id,
      action: "like"
    )
    notification.save if notification.valid?
  end
end
