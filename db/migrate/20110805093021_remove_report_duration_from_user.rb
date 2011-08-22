class RemoveReportDurationFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :reportduration
  end

  def self.down
    add_column :users, :reportduration, :integer
  end
end
