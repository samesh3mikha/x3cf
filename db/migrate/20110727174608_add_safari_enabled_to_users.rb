class AddSafariEnabledToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :safari_enabled, :boolean, :default => false
  end

  def self.down
    remove_column :users, :safari_enabled
  end
end
