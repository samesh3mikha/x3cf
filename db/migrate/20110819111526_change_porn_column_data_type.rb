class ChangePornColumnDataType < ActiveRecord::Migration
  def self.up
    change_column :weblogs, :porn, :string, :default => "checking"
  end

  def self.down
    change_column :weblogs, :porn, :boolean    
  end
end
