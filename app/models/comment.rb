class Comment < ApplicationRecord
  validates :comment, length: { maximum: 250 }
  validates :comment, presence: true

  belongs_to :post
  belongs_to :user
  has_many :comment_likes, dependent: :destroy
  has_many :liking_users, through: :comment_likes, source: :user
end
