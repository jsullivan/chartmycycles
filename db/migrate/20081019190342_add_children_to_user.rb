class AddChildrenToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :children, :integer
  end

  def self.down
    remove_column :users, :children
  end
end
