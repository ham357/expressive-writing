json.id @comment.id
json.comment @comment.comment
if @comment.user.image.present?
  json.user_image @comment.user.image.url
else
  json.user_image "/images/no_image.jpeg"
end
json.user_name @comment.user.nickname
