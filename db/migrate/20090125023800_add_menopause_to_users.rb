class AddMenopauseToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :menopause, :boolean
  end

  def self.down
    remove_column :users, :menopause
  end
end
