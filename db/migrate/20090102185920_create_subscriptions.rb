class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.integer :interval
      t.string :status
      t.datetime :last_charged_at
      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
