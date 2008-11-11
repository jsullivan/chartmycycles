class CreateMoodyComments < ActiveRecord::Migration
  def self.up
    create_table :moody_comments do |t|
      t.string :comment
      t.integer :entry_id
      t.timestamps
    end
  end

  def self.down
    drop_table :moody_comments
  end
end
