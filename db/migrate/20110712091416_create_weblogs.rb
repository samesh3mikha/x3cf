class CreateWeblogs < ActiveRecord::Migration
  def self.up
    create_table :weblogs do |t|
      t.string :url
      t.string :title
      t.datetime :visited_at
      t.string :email_status
      t.string :source
      t.string :source_id

      t.timestamps
    end
  end

  def self.down
    drop_table :weblogs
  end
end
