class AddPornToWeblog < ActiveRecord::Migration
  def self.up
    add_column :weblogs, :porn, :boolean, :default => false
  end

  def self.down
    remove_column :weblogs, :porn
  end
end
