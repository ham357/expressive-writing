class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :visiter_id, null: false
      t.integer :visited_id, null: false
      t.integer :post_id
      t.integer :comment_id
      t.string :action, null: false
      t.boolean :checked, default: false, null: false
      t.timestamps

      t.index %i[visiter_id visited_id]
    end
  end
end
