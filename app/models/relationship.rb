class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :follow, class_name: 'User'

  validates :user, presence: true
  validates :follow, presence: true
  validates_uniqueness_of :user_id, scope: :follow_id

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      visiter_id: current_user.id,
      visited_id: follow_id,
      action: "follow"
    )
    notification.save if notification.valid?
  end
end
