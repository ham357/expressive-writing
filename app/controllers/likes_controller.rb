class LikesController < ApplicationController
  before_action :set_variables

  def like
    like = current_user.likes.new(post: @post)
    like.save
    @post.create_notification_by(current_user) unless current_user == @post.user
  end

  def unlike
    like = current_user.likes.find_by(post: @post)
    like.destroy
  end

  private

  def set_variables
    @post = Post.find(params[:post_id])
    @id_name = "#like-link-#{@post}"
    @id_heart = "#heart-#{@post}"
  end
end
