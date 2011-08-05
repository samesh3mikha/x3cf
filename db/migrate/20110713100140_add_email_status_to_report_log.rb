class AddEmailStatusToReportLog < ActiveRecord::Migration
  def self.up   
     add_column :report_logs, :email_status, :string   
  end

  def self.down 
    remove_column :report_logs, :email_status
  end
end
