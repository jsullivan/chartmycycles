require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_should_process_order_successfully
      r = Order.new
      r.status = 0  # want to make sure this has a "pending" status.
      r.step = "checkout"    # need to set this - validations for cc info run only if this is set
      r.card_type = "Visa"
      r.card_number="4779139500118580"
      r.card_verification_value = "410"
      r.card_expiration_month = "10"
      r.card_expiration_year = "2008"
      r.billing_city = "Springfield"
      r.billing_state = "NT"
      r.billing_zip =" 54703"
      r.billing_address ="123 Fake Street"
      assert r.process
      assert_equal(1, r.status)
  end
  
end
