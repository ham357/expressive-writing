class PostDraftsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post_draft_last = current_user.post_drafts.order("updated_at").last
    redirect_to post_draft_path(@post_draft_last.id)
  end

  def new
    @post_draft = PostDraft.new
  end

  def create
    if params[:commit] == 'save'
      post_create
    elsif params[:commit] == 'draft'
      draft_create
    else
      render new_post_draft_path, alert: "createエラー"
    end
  end

  def draft_create
    @post_draft = PostDraft.new(post_draft_params)
    if @post_draft.save
      respond_to do |format|
        format.html do
          redirect_to post_draft_path(@post_draft.id), notice: "下書きが作成されました"
        end
        format.js
      end
    else
      respond_to do |format|
        format.html { render new_post_draft_path }
        format.js
      end
    end
  end

  def post_create
    @post = Post.new(post_draft_params)
    if @post.save
      respond_to do |format|
        format.html do
          @post_draft&.destroy
          redirect_to root_path, notice: "投稿が完了しました"
        end
      end
    else
      respond_to do |format|
        format.html { render new_post_draft_path, notice: "createエラー" }
      end
    end
  end

  def commit_value_check
    if params[:commit] == 'save'
      post_create
    elsif params[:commit] == 'draft'
      redirect_to post_draft_path(@post_draft.id), notice: "下書きが作成されました"
    else
      render new_post_draft_path, alert: "commit_value_checkエラー"
    end
  end

  def update
    @post_draft = PostDraft.find(params[:id])
    if @post_draft.update(post_draft_params) && @post_draft.user_id == current_user.id
      commit_value_check
    else
      redirect_to root_path, alert: "updateエラー"
    end
  end

  def destroy
    post = PostDraft.find(params[:id])
    post.destroy if post.user_id == current_user.id
    redirect_to post_drafts_path, notice: "下書きを削除しました"
  end

  def edit
    @post_draft = PostDraft.find(params[:id])
  end

  def show
    @post_drafts = current_user.post_drafts.order("updated_at DESC")
    @post_draft = PostDraft.find(params[:id])
  end

  private

  def post_draft_params
    params.require(:post_draft).permit(:title, :contents, :image).merge(user_id: current_user.id)
  end
end
