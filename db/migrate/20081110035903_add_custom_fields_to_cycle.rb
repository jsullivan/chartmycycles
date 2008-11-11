class AddCustomFieldsToCycle < ActiveRecord::Migration
  def self.up
    add_column :cycles, :custom1, :string
    add_column :cycles, :custom2, :string
    add_column :cycles, :custom3, :string
    add_column :cycles, :custom4, :string
  end

  def self.down
    remove_column :cycles, :custom1
    remove_column :cycles, :custom2
    remove_column :cycles, :custom3
    remove_column :cycles, :custom4
  end
end
