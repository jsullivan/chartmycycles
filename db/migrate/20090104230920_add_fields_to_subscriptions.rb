class AddFieldsToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :authorization, :string
    add_column :subscriptions, :message, :string
    add_column :subscriptions, :user_id, :integer

  end

  def self.down
    remove_column :subscriptions, :authorization
    remove_column :subscriptions, :message
    remove_column :subscriptions, :user_id
  end
end
