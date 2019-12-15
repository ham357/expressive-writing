class Post < ApplicationRecord
  validates :title, length: { maximum: 50 }
  validates :contents, length: { maximum: 1000 }
  validates :contents, presence: true
  mount_uploader :image, ImageUploader
  acts_as_taggable

  belongs_to :user
  has_many   :comments
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  has_many :notifications, dependent: :destroy
  has_many :favorites
  has_many :favorited_users, through: :favorites, source: :user
  paginates_per 20

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      post: self,
      visited: user,
      action: "like"
    )
    notification.save if notification.valid?
  end
end
