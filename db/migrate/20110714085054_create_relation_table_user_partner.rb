class CreateRelationTableUserPartner < ActiveRecord::Migration
  def self.up
    create_table :partners_users, :id => false do |t|
      t.column :user_id, :integer
      t.column :partner_id, :integer
    end
    
    add_index :partners_users, [:user_id, :partner_id]
    add_index :partners_users, :partner_id
  end

  def self.down
    drop_table :partners_users
  end
end
