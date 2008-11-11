class AddChartDateToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :chart_date, :datetime
  end

  def self.down
    remove_column :entries, :chart_date
  end
end
