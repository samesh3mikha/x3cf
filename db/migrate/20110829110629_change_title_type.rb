class ChangeTitleType < ActiveRecord::Migration
  def self.up
    change_column :weblogs, :title, :text
  end

  def self.down
    change_column :weblogs, :title, :string
  end
end
