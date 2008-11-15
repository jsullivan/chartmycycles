class AddPhaseSupportToCycles < ActiveRecord::Migration
  def self.up
    add_column :cycles, :phase_one_end, :datetime
    add_column :cycles, :phase_three_start, :datetime
  end

  def self.down
    remove_column :cycles, :phase_one_end
     remove_column :cycles, :phase_three_start
  end
end
