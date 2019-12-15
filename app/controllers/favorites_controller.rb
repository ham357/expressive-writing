class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variables, only: %i[favorite unfavorite]

  def index
    @favorites = current_user.favorites.order("created_at DESC")
  end

  def favorite
    favorite = current_user.favorites.new(post: @post)
    favorite.save
    @post.create_notification_by(current_user) unless current_user == @post.user
  end

  def unfavorite
    favorite = current_user.favorites.find_by(post: @post)
    favorite.destroy
  end

  private

  def set_variables
    @post = Post.find(params[:post_id])
    @f_id_name = "#favorite-link-#{@post}"
    @id_star = "#star-#{@post}"
  end
end
