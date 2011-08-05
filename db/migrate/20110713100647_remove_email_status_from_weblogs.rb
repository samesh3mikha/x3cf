class RemoveEmailStatusFromWeblogs < ActiveRecord::Migration
  def self.up
    remove_column :weblogs, :email_status
  end

  def self.down
    add_column :weblogs, :email_status, :string
  end
end
