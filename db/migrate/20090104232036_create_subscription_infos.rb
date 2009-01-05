class CreateSubscriptionInfos < ActiveRecord::Migration
  def self.up
    create_table :subscription_infos do |t|
      t.string :authorization, :message
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :subscription_infos
  end
end
