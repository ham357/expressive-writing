class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook twitter google_oauth2]

  validates :nickname, presence: true, length: { maximum: 20 }
  validates :comment, length: { maximum: 200 }
  mount_uploader :image, ImageUploader

  has_many :posts, dependent: :destroy
  has_many :post_drafts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :comment_likes, dependent: :destroy
  has_many :like_comments, through: :comment_likes, source: :comment
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user
  has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post

  def already_liked?(post)
    likes.exists?(post_id: post.id)
  end

  def already_comment_liked?(comment)
    comment_likes.exists?(comment_id: comment.id)
  end

  def follow(other_user)
    relationships.find_or_create_by(follow_id: other_user.id) unless self == other_user
  end

  def unfollow(other_user)
    relationship = relationships.find_by(follow_id: other_user.id)
    relationship&.destroy
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  def followers_count
    user_followers_count = Relationship.where(follow_id: id).count
    user_followers_count.present? ? user_followers_count : 0
  end

  def following_count
    user_following_count = Relationship.where(user_id: id).count
    user_following_count.present? ? user_following_count : 0
  end

  def already_favorited?(post)
    favorites.exists?(post_id: post.id)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = dummy_email(auth)
      user.password = Devise.friendly_token[0, 20]
      user.remote_image_url = auth.info.image
      if auth.provider == 'twitter'
        user.nickname = auth.info.nickname
      else
        user.nickname ||= auth.info.email.sub!(/@.*/m, "")
      end
    end
  end

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
  private_class_method :dummy_email
end
