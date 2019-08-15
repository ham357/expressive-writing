module CommentsHelper
  def update_comment?(comment)
    comment.created_at != comment.updated_at
  end
end
