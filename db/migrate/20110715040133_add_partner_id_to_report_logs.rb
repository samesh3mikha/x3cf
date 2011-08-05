class AddPartnerIdToReportLogs < ActiveRecord::Migration
  def self.up
    add_column :report_logs, :partner_id, :integer
  end

  def self.down
    remove_column :report_logs, :partner_id
  end
end
