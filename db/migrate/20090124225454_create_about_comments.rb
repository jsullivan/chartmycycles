class CreateAboutComments < ActiveRecord::Migration
  def self.up
    create_table :about_comments do |t|
      t.integer :about_id, :user_id
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :about_comments
  end
end
