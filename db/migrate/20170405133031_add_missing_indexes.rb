migration_superclass = if ActiveRecord::VERSION::MAJOR >= 5
  ActiveRecord::Migration["#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"]
else
  ActiveRecord::Migration
end

class AddMissingIndexes < migration_superclass
  def self.up
    add_index addresses_table_name, :user_id
    add_index addresses_table_name, :deleted_at
  end

  def self.down
    remove_index addresses_table_name, :user_id
    remove_index addresses_table_name, :deleted_at
  end

  private

  def self.addresses_table_name
    table_exists?('addresses') ? :addresses : :spree_addresses
  end
end
