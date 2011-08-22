class ChangePornColumnDataType < ActiveRecord::Migration
  def self.up
    change_column :weblogs, :porn, :string, :default => "not_checked"
  end

  def self.down
    change_column :weblogs, :porn, :boolean, :default => false   
  end
end
