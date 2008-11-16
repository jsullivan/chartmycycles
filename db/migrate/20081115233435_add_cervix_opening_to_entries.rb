class AddCervixOpeningToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :cervix_opening, :string
  end

  def self.down
    remove_column :entries, :cervix_opening
  end
end
