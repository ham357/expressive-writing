class PostDraftsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy edit update]

  def new
    @post_draft = PostDraft.new
  end

  def create
    if params[:commit] == 'draft'
      @post_draft = PostDraft.new(post_draft_params)
      if @post_draft.save
        respond_to do |format|
          flash[:notice] = '下書きが作成されました'
          format.html { redirect_to root_path }
          format.json
        end
      else
        respond_to do |format|
          format.html { render new_post_draft_path }
          format.json
        end
      end
    elsif params[:commit] == 'save'
      @post = Post.new(post_draft_params)
      if @post.save
        respond_to do |format|
          flash[:notice] = '投稿が完了しました'
          format.html { redirect_to root_path }
          format.json
        end
      else
        respond_to do |format|
          format.html { render new_post_draft_path }
          format.json
        end
      end
    else
      render new_post_draft_path
    end
  end

  private

  def post_draft_params
    params.require(:post_draft).permit(:title, :contents, :image).merge(user_id: current_user.id)
  end
end
