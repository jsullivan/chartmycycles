class TransactiontestController < ApplicationController
  
    def process_payment
      # MOST BASIC EXAMPLE 

      # random amount from $10 to $35 - this prevents duplicate transaction errors
      charge_amount = rand(1000)+2500 

      login_id = "358gbVPPaM4q"
      transaction_key = "52D3duM39y3a7Y5j"

      number = '4222222222222' #Authorize.net test card, error-producing
      #number = '4007000000027' #Authorize.net test card, non-error-producing
      credit_card = ActiveMerchant::Billing::CreditCard.new(
      :number => number,
      :month => 8,
      :year => 2009,
      :first_name => 'Tobias',
      :last_name => 'Luetke',
      :type => 'visa',
      :verification_value => 345
      )

      if credit_card.valid?
      gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
       :login  => login_id,
       :password => transaction_key,
       :test => true
      )
      response = gateway.purchase(charge_amount, credit_card)

      if response.success?
       @result = "success!"
      else
       @result =  StandardError.new( response.message )
      end
    else
      @result = "wtf?"
end
    
end
end