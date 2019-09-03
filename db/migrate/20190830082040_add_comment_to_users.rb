class AddCommentToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :comment, :text, after: :image
  end
end
