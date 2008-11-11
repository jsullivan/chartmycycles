class RemovePostIdFromForums < ActiveRecord::Migration
  def self.up
    remove_column :forums, :post_id
  end

  def self.down
    add_column :forums, :post_id, :integer
  end
end
