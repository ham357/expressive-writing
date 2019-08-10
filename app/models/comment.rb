class Comment < ApplicationRecord
  validates :comment, length: { maximum: 250 }
  validates :comment, presence: true

  belongs_to :post
  belongs_to :user
end
