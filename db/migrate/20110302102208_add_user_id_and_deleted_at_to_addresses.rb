class AddUserIdAndDeletedAtToAddresses < ActiveRecord::Migration
  def self.up
    change_table :spree_addresses do |t|
      t.integer :user_id
      t.datetime :deleted_at
    end

    add_index :spree_addresses, :user_id
  end

  def self.down
    remove_index :spree_addresses, :user_id

    change_table :spree_addresses do |t|
      t.remove :deleted_at
      t.remove :user_id
    end
  end
end
