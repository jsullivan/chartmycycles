class RemoveAboutStuffFromUsersModel < ActiveRecord::Migration
  def self.up
    remove_column :users, :about
    remove_column :users, :about_created_at
    
  end

  def self.down
    add_column :users, :about, :string
    add_column :users, :about_created_at, :datetime
  end
end
