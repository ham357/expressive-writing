json.id @comment.id
json.comment @comment.comment
if @comment.user.image.present?
  json.image @comment.user.image.url
else
  json.image "/images/no_image.jpeg"
end
json.name @comment.user.nickname
