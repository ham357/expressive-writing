class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy edit update show]
  before_action :all_tags, only: %i[edit new show]

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      @posts = Post.where(user_id: user.id).page(params[:page]).order("created_at DESC")
    elsif params[:tag]
      @posts = Post.tagged_with(params[:tag]).page(params[:page]).order("created_at DESC")
    else
      @posts = Post.includes(:user).page(params[:page]).order("created_at DESC")
    end
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

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user)
    gon.user_tags = @post.tag_list
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params) && @post.user_id == current_user.id
      redirect_to root_path
    else
      respond_to do |format|
        format.html { render "edit" }
        format.json
      end
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy if post.user_id == current_user.id
    redirect_to root_path
  end

  def edit
    @post = Post.find(params[:id])
    gon.user_tags = @post.tag_list
  end

  def all_tags
    gon.tags = ActsAsTaggableOn::Tag.all
  end

  private

  def post_params
    params.require(:post).permit(:title, :contents, :image, :tag_list).merge(user_id: current_user.id)
  end
end
