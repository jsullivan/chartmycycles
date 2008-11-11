class RemoveUserLoginAttribute < ActiveRecord::Migration
  def self.up
  remove_column :users, :login
  end

  def self.down
  end
end
