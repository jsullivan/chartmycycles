class AddCommentToEnry < ActiveRecord::Migration
  def self.up
    add_column :entries, :comment, :text
  end

  def self.down
    remove_column :entries, :comment
  end
end
