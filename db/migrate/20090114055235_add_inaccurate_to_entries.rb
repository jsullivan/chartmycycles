class AddInaccurateToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :inaccurate, :boolean
  end

  def self.down
    remove_column :entries, :inaccurate
  end
end
