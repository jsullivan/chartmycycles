class CreateAbouts < ActiveRecord::Migration
   def self.up
      create_table :abouts do |t|
        t.column :user_id, :integer
        t.column :title, :string
        t.column :body, :string
        t.timestamps
      end
    end

    def self.down
      drop_table :abouts
    end
  end

