class UsersController < ApplicationController
  def params_value_check
    if params[:value] == "following"
      @users = User.joins("LEFT OUTER JOIN relationships ON users.id = relationships.follow_id").where(relationships: { user_id: @user.id }).order("relationships.created_at DESC")
    elsif params[:value] == "followers"
      @users = User.joins("LEFT OUTER JOIN relationships ON users.id = relationships.user_id").where(relationships: { follow_id: @user.id }).order("relationships.created_at DESC")
    end
  end

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      params_value_check
    else
      @users = User.where('nickname LIKE(?) and id != ?', "#{params[:keyword]}%", current_user).order('nickname')
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
    if @user.update(user_params) && @user.id == current_user.id
      redirect_to user_path(@user.id), notice: "コメントが更新されました"
    else
      render "registrations/edit", alert: "user updateエラー"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :image, :comment)
  end
end
