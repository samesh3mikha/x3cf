class CreateMobileapps < ActiveRecord::Migration
  def self.up
    create_table :mobileapps do |t|
      t.string :app_name
      t.string :package_name
      t.boolean :deleted,        :default => false
      t.boolean :sent_email,     :default => false
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :mobileapps
  end
end
