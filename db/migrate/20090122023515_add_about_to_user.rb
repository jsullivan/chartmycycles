class AddAboutToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :about, :string
  end

  def self.down
    remove_column :users, :about
  end
end
