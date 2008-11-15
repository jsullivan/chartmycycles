class DropAllCommentTables < ActiveRecord::Migration
  def self.up
    drop_table :intercourse_comments
    drop_table :peak_comments
    drop_table :vaginal_sensation_comments
    drop_table :cervix_comments
    drop_table :mucus_comments
    drop_table :insomnia_comments
    drop_table :moody_comments
    drop_table :acne_comments
    drop_table :bloating_comments
    drop_table :cramp_comments
    drop_table :period_comments
    drop_table :temp_comments
    
    
    
    
    
    
    
    
    
  end

  def self.down
  end
end
