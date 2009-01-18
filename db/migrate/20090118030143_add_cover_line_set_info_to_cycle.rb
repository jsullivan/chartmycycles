class AddCoverLineSetInfoToCycle < ActiveRecord::Migration
  def self.up
    add_column :cycles, :cover_line_entry_day, :integer
    add_column :cycles, :cover_line_entry_temp, :integer
  end

  def self.down
    remove_column :cycles, :cover_line_entry_day
    remove_column :cycles, :coer_line_entry_temp
  end
end
