class Comment < ApplicationRecord
  validates :comment, length: { maximum: 250 }

  belongs_to :post
  belongs_to :user
end
