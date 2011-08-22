class AddSafariChangedTime < ActiveRecord::Migration
  def self.up
    add_column :users, :safari_changed_time, :datetime
  end

  def self.down
    remove_column :users, :safari_changed_time
  end
end
