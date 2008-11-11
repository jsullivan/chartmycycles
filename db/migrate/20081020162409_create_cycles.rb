class CreateCycles < ActiveRecord::Migration
  def self.up
    create_table :cycles do |t|
      t.datetime :started, :ended
      t.integer :user_id 
      t.timestamps
    end
  end

  def self.down
    drop_table :cycles
  end
end
