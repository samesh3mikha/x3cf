class ChangeDefaultForPorn < ActiveRecord::Migration
  def self.up
    change_column_default(:weblogs, :porn, "queued")
  end

  def self.down
    change_column_default(:weblogs, :porn, "pending")
  end
end
