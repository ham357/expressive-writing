module PostsHelper
  def check_user_icon(post)
    if post.user.image.present?
      image_tag post.user.image.to_s, class: 'circle responsive-img'
    else
      image_tag "/images/no_image.jpeg", class: 'circle responsive-img'
    end
  end
end
