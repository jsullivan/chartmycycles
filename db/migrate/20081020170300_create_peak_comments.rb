class CreatePeakComments < ActiveRecord::Migration
  def self.up
    create_table :peak_comments do |t|
      t.string :comment
      t.integer :entry_id
      t.timestamps
    end
  end

  def self.down
    drop_table :peak_comments
  end
end
