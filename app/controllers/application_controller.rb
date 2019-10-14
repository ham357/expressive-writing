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
    if params[:q].present?
      if params[:q]["title_or_contents_has_every_term"].include?("title:") || params[:q]["title_or_contents_has_every_term"].include?("contents:")
        q = { "g" => {} } if defined? q
        params[:q]["title_or_contents_has_every_term"].split.map.with_index do |t, index|
          if t.include?("title:") || t.include?("contents:")
            keyword = t.match(":")
            name = keyword.pre_match
            value = keyword.post_match
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
    end
    @search = Post.ransack(q)
    @posts = @search.result.includes(:user).page(params[:page]).order("created_at DESC")
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[nickname image])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[nickname image])
  end
end
