module UsersHelper
  def check_user_icon(user)
    if user.image.present?
      image_tag user.image.to_s, class: 'circle responsive-img'
    else
      image_tag "/images/no_image.jpeg", class: 'circle responsive-img'
    end
  end
end
