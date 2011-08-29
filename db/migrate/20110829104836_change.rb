class Change < ActiveRecord::Migration
  def self.up
    change_column :weblogs, :url, :text, :limit => 500
  end

  def self.down
    change_column :weblogs, :url, :text
  end
end
