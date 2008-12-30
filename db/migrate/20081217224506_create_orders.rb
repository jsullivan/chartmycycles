class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
        t.string :confirmation_number, :payment_transaction_id, :billing_address, :billing_city, :billing_state, :billing_zip
        t.datetime :confirmed_at, :processed_at, :cancelled_at
        t.integer :user_id, :status, :total_cost
        t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
