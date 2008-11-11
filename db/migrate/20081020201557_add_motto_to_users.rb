class AddMottoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :motto, :string
  end

  def self.down
    remove_column :users, :motto
  end
end
