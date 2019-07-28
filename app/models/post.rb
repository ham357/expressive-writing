class Post < ApplicationRecord
  validates :title, length: { maximum: 50 }
  validates :contents, length: { maximum: 1000 }
  validates :contents, presence: true
  mount_uploader :image, ImageUploader

  belongs_to :user
end
