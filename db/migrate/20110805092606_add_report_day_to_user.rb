class AddReportDayToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :report_day, :integer, :default => 1
  end

  def self.down
    remove_column :users, :report_day
  end
end
