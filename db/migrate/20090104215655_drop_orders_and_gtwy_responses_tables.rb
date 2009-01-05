class DropOrdersAndGtwyResponsesTables < ActiveRecord::Migration
  def self.up
    drop_table :orders
    drop_table :gateway_responses
  end

  def self.down
  end
end
