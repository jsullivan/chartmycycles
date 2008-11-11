class AddMemberBooleanToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :member, :boolean, :default => false
  end

  def self.down
    remove_column :users, :member
  end
end
