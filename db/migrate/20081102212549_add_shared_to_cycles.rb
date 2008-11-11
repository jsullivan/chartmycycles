class AddSharedToCycles < ActiveRecord::Migration
  def self.up
    add_column :cycles, :shared, :boolean, :default => false
  end

  def self.down
    remove_column :cycles, :shared
  end
end
