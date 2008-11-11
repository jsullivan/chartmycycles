class CreateCrampComments < ActiveRecord::Migration
  def self.up
    create_table :cramp_comments do |t|
      t.string :comment
      t.integer :entry_id
      t.timestamps
    end
  end

  def self.down
    drop_table :cramp_comments
  end
end
