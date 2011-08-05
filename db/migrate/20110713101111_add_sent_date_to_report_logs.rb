class AddSentDateToReportLogs < ActiveRecord::Migration
  def self.up
    add_column :report_logs, :sent_date, :datetime
  end

  def self.down
    remove_column :report_logs, :sent_date
  end
end
