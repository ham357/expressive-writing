class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy edit update]

  def index
    @posts = Post.includes(:user).where(user: current_user).page(params[:page]).per(5).order("created_at DESC")
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json
      end
    else
      respond_to do |format|
        format.html { render new_post_path }
        format.json
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :contents, :image).merge(user_id: current_user.id)
  end
end
