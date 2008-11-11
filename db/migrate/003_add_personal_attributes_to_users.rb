class AddPersonalAttributesToUsers < ActiveRecord::Migration
  def self.up
  add_column :users,  :charting_for_id, :integer
  end

  def self.down
  remove_column :users, :charting_for_id
  end
end
