class ApplicationController < ActionController::Base
  before_action :set_search
  before_action :configure_permitted_parameters, if: :devise_controller?

  def notifications_list
    @notifications = current_user.passive_notifications.page(params[:page])
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  def set_search
    @search = Post.ransack(params[:q])
    @posts = @search.result.page(params[:page]).order("created_at DESC")
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[nickname image])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[nickname image])
  end
end
