class CreateCervixComments < ActiveRecord::Migration
  def self.up
    create_table :cervix_comments do |t|
      t.string :comment
      t.integer :entry_id
      t.timestamps
    end
  end

  def self.down
  end
end
