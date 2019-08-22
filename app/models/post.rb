class Post < ApplicationRecord
  validates :title, length: { maximum: 50 }
  validates :contents, length: { maximum: 1000 }
  validates :contents, presence: true
  mount_uploader :image, ImageUploader

  belongs_to :user
  has_many   :comments
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  paginates_per 20
end
