class AddAuthenticationTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :authentication_token, :string 
    add_index :users, :authentication_token, :unique => true
    User.reset_column_information
    User.all.each { |user| user.ensure_authentication_token! }
  end

  def self.down
    remove_column :users, :authentication_token
  end
end
