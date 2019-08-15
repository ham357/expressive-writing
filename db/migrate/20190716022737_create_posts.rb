class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :contents, null: false
      t.string :image
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
