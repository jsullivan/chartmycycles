class AddBillingToUsers < ActiveRecord::Migration
  def self.up
     add_column :users, :customer_cim_id, :integer
     add_column :users, :customer_payment_profile_id, :integer
     add_column :users, :customer_billing_address_id, :integer
     add_column :users, :interval, :integer
  end

  def self.down
    remove_column :users, :customer_cim_id
    remove_column :users, :customer_payment_profile_id
    remove_column :users, :customer_billing_address_id  
    remove_column :users, :interval 
  end
end
