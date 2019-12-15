class UsersController < ApplicationController
  def params_value_check
    if params[:value] == "following"
      @users = User.joins("LEFT OUTER JOIN relationships ON users.id = relationships.follow_id").where(relationships: { user: @user }).order("relationships.created_at DESC")
    elsif params[:value] == "followers"
      @users = User.joins("LEFT OUTER JOIN relationships ON users = relationships.user").where(relationships: { follow: @user }).order("relationships.created_at DESC")
    end
  end

  def index
    if params[:user]
      @user = User.find(params[:user])
      params_value_check
    else
      @users = User.where('nickname LIKE(?)', "#{params[:keyword]}%").order('nickname')
      respond_to do |format|
        format.html
        format.json
        format.js
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params) && @user == current_user
      redirect_to user_path(@user), notice: "コメントが更新されました"
    else
      render "registrations/edit", alert: "user updateエラー"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :image, :comment)
  end
end
