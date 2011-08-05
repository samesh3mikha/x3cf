class AddReportDurationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :reportduration, :integer
  end

  def self.down
    remove_column :users, :reportduration
  end
end
