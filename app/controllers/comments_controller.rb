class CommentsController < ApplicationController
  before_action :authenticate_user!

  def edit; end

  def create
    @comment = Comment.create(comment: comment_params[:comment], post_id: comment_params[:post_id], user_id: current_user.id)
    @comment.create_notification_by(current_user) unless current_user.id == @comment.user_id
    respond_to do |format|
      format.html { redirect_to post_path(params[:post_id]) }
      format.json
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.comment = params[:comment]
    return unless @comment.save && @comment.user_id == current_user.id

    respond_to do |format|
      format.html { redirect_to post_path(@comment.post_id), notice: 'メッセージが編集されました' }
      format.json
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment).merge(params.permit(:post_id))
  end
end
