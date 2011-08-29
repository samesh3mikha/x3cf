class ChangeUrlType < ActiveRecord::Migration
  def self.up
    change_column :weblogs, :url, :text
  end

  def self.down
    change_column :weblogs, :url, :string
  end
end
