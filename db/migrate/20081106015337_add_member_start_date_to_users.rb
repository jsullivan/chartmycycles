class AddMemberStartDateToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :member_start_date, :datetime
  end

  def self.down
    remove_column :users, :member_start_date
  end
end
