class CreateChartingFors < ActiveRecord::Migration
  def self.up
    create_table :charting_fors do |t|
      t.string :chart_type
      t.timestamps
    end
    c = ChartingFor.new
    c.chart_type = 'Conception'
    c.save
    c = ChartingFor.new
    c.chart_type = 'Prevention'
    c.save
  end

  def self.down
    drop_table :charting_fors
  end
end
