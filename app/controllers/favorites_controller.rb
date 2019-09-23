class FavoritesController < ApplicationController
  before_action :set_variables

  def favorite
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.save
    @post.create_notification_by(current_user) unless current_user.id == @post.user_id
  end

  def unfavorite
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end

  private

  def set_variables
    @post = Post.find(params[:post_id])
    @f_id_name = "#favorite-link-#{@post.id}"
    @id_star = "#star-#{@post.id}"
  end
end
