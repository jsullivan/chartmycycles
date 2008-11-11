class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.string :topic
      t.integer :user_id, :post_id
      t.timestamps
    end
    
    
  f = Forum.new
  f.topic = "Introduce yourself"
  f.save
  f = Forum.new 
  f.topic = "Get help with your cycles"
  f.save
  f = Forum.new
  f.topic = "Discuss charting methods"
  f.save
  f = Forum.new
  f.topic = "Request new features"
  f.save
  f = Forum.new
  f.topic = "Talk about anything"
  f.save
  end

  def self.down
    drop_table :forums
  end
end
