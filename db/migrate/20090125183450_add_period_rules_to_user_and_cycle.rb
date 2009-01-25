class AddPeriodRulesToUserAndCycle < ActiveRecord::Migration
  def self.up
    add_column :users, :period_rule_one, :integer
    add_column :cycles, :period_rule_two, :integer
  end

  def self.down
    remove_colum :users, :period_rule_one
    remove_column :cycles, :period_rule_two
  end
end
