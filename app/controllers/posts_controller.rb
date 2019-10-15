class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy edit update show]
  before_action :all_tags, only: %i[edit new show]

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      @posts = Post.where(user_id: user.id).page(params[:page]).order("created_at DESC")
    elsif params[:tag]
      @posts = Post.tagged_with(params[:tag]).page(params[:page]).order("created_at DESC")
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

  def remake_query(keyword)
    if keyword.include?("title:") || keyword.include?("contents:")
      q = { "g" => {} } if defined? q
      keyword.split.map.with_index do |t, index|
        if t.include?("title:") || t.include?("contents:")
          word = t.match(":")
          name = word.pre_match
          value = word.post_match
          q["g"].merge!(
            index.to_s => {
              "c" => {
                "0" => {
                  "a" => { "0" => { "name" => name.to_s } },
                  "p" => "cont",
                  "v" => { "0" => { "value" => value.to_s } }
                }
              }
            }
          )
        else
          q["g"].merge!(
            index.to_s => {
              "title_or_contents_cont" => t.to_s
            }
          )
        end
      end
    else
      q = params[:q]
    end

    q
  end

  def search
    @temp_search_word = params[:q]["title_or_contents_has_every_term"]
    q = remake_query(params[:q]["title_or_contents_has_every_term"])
    @search = Post.ransack(q)
    @search.build_condition if @search.conditions.empty?
    @posts = @search.result.includes(:user).page(params[:page]).order("created_at DESC")
  end

  private

  def post_params
    params.require(:post).permit(:title, :contents, :image, :tag_list).merge(user_id: current_user.id)
  end
end
