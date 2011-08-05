class CreateReportLogs < ActiveRecord::Migration
  def self.up
    create_table :report_logs do |t|
      t.datetime :last_sent
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :report_logs
  end
end
