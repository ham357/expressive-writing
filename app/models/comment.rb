class Comment < ApplicationRecord
  validates :comment, length: { maximum: 250 }
  mount_uploader :image, ImageUploader

  belongs_to :post
  belongs_to :user
end
