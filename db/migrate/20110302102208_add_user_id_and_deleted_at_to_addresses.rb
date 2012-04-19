class AddUserIdAndDeletedAtToAddresses < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :user_id, :integer
    add_column :spree_addresses, :deleted_at, :datetime
    add_index :spree_addresses, :user_id
  end
end
