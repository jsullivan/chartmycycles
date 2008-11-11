class AddCurrentToCycles < ActiveRecord::Migration
  def self.up
    add_column :cycles, :current, :boolean, :default => true
  end

  def self.down
    remove_column :cycles, :current
  end
end
