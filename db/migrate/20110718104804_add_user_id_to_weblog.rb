class AddUserIdToWeblog < ActiveRecord::Migration
  def self.up
    add_column :weblogs, :user_id, :integer
  end

  def self.down
    remove_column :weblogs, :user_id
  end
end
