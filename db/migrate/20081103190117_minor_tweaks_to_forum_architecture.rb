class MinorTweaksToForumArchitecture < ActiveRecord::Migration
  def self.up
    add_column :posts, :forum_id, :integer
  end

  def self.down
    remove_column :posts, :forum_id
  end
end
