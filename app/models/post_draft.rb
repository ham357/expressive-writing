class PostDraft < ApplicationRecord
  validates :title, length: { maximum: 50 }
  validates :contents, length: { maximum: 1000 }
  mount_uploader :image, ImageUploader
  acts_as_taggable

  belongs_to :user
end
