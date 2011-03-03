class AddUserIdAndDeletedAtToAddresses < ActiveRecord::Migration
  def self.up
    change_table :addresses do |t|
      t.integer :user_id
      t.datetime :deleted_at
    end
  end

  def self.down
    change_table :addresses do |t|
      t.remove :deleted_at
      t.remove :user_id    
    end
  end
end
