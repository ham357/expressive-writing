class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.create(comment: comment_params[:comment], post_id: comment_params[:post_id], user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to post_path(params[:post_id]) }
      format.json
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment).merge(params.permit(:post_id))
  end
end
