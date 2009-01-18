class AddCoverLineSetInfoToCycle < ActiveRecord::Migration
  def self.up
    add_column :cycles, :cover_line_entry_day, :integer
    add_column :cycles, :cover_line_entry_temp, :float
  end

  def self.down
    remove_column :cycles, :cover_line_entry_day
    remove_column :cycles, :cover_line_entry_temp
  end
end
