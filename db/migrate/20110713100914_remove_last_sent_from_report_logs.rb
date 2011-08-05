class RemoveLastSentFromReportLogs < ActiveRecord::Migration
  def self.up
    remove_column :report_logs, :last_sent
  end

  def self.down
    add_column :report_logs, :last_sent, :datetime
  end
end
