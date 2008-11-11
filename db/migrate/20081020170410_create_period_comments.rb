class CreatePeriodComments < ActiveRecord::Migration
  def self.up
    create_table :period_comments do |t|
      t.string :comment
      t.integer :entry_id
      t.timestamps
    end
  end

  def self.down
    drop_table :period_comments
  end
end
