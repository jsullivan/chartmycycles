class UpdateEntriesToSupportNonBooleans < ActiveRecord::Migration
  def self.up
    remove_column :entries, :cervix
    remove_column :entries, :mucus
    remove_column :entries, :vaginal_sensation
    add_column :entries, :cervix_position, :string
    add_column :entries, :cervix_firmness, :string
    add_column :entries, :mucus, :string
    add_column :entries, :vaginal_sensation, :string
  end

  def self.down
    
  end
end
