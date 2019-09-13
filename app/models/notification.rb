class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :post, optional: true
  belongs_to :user, foreign_key: "visiter_id"
  belongs_to :comment, optional: true
  validates  :action, presence: true
  paginates_per 10
end
