class CommentLikesController < ApplicationController
  before_action :set_variables

  def comment_like
    comment_like = current_user.comment_likes.new(comment_id: @comment.id)
    comment_like.save
  end

  def comment_unlike
    comment_like = current_user.comment_likes.find_by(comment_id: @comment.id)
    comment_like.destroy
  end

  private

  def set_variables
    @comment = Comment.find(params[:comment_id])
    @id_name = "#comment-like-link-#{@comment.id}"
    @id_heart = "#comment-heart-#{@comment.id}"
  end
end
