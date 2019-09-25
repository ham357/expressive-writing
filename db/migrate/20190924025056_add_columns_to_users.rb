class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :uid, :string, after: :remember_created_at
    add_column :users, :provider, :string, after: :uid

    add_index :users, %i[uid provider], unique: true
  end
end
