class RemoverSentDateFromReportLogs < ActiveRecord::Migration
  def self.up 
     remove_column :report_logs, :sent_date         
  end

  def self.down
    add_column :report_logs, :sent_date, :datetime 
  end
end
