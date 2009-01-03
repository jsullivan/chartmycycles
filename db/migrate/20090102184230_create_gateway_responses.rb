class CreateGatewayResponses < ActiveRecord::Migration
  def self.up
    create_table :gateway_responses do |t|
      t.string :email, :message
      t.integer :customer_cim_id, :customer_payment_profile_id, :customer_billing_address_id, :customer_shipping_address_id
      t.timestamps
    end
  end

  def self.down
    drop_table :gateway_responses
  end
end
