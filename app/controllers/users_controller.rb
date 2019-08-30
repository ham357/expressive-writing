class UsersController < ApplicationController
  def index
    @users = User.all
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
