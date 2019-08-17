class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, presence: true, length: { maximum: 20 }
  mount_uploader :image, ImageUploader

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :comment_likes, dependent: :destroy
  has_many :like_comments, through: :comment_likes, source: :comment

  def already_liked?(post)
    likes.exists?(post_id: post.id)
  end

  def already_comment_liked?(comment)
    comment_likes.exists?(comment_id: comment.id)
  end
end
