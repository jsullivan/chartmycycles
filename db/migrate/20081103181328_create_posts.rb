class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.column :user_id, :integer
      t.column :title, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
