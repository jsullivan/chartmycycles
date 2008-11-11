class CreateVaginalSensationComments < ActiveRecord::Migration
  def self.up
    create_table :vaginal_sensation_comments do |t|
      t.string :comment
      t.integer :entry_id
      t.timestamps
    end
  end

  def self.down
    drop_table :vaginal_sensation_comments
  end
end
