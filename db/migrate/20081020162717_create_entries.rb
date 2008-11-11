class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :user_id, :cycle_id, :cervix, :mucus
      t.boolean :peak, :intercourse, :period, :moody, :vaginal_sensation, :insomnia, :acne, :bloating, :cramps
      t.float :temp 
      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
