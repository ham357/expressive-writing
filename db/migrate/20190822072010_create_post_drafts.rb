class CreatePostDrafts < ActiveRecord::Migration[5.2]
  def change
    create_table :post_drafts do |t|
      t.string :title
      t.text :contents, null: false
      t.string :image
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
