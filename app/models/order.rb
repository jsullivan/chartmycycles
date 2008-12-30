class Order < ActiveRecord::Base
  
  include ActiveMerchant::Billing
  belongs_to :user
  validates_presence_of :billing_address,
      :billing_city,
      :billing_state,
      :billing_zip,
      :card_type,
      :card_verification_value, :card_number, :card_expiration_month, :card_expiration_year, 
      :if=> Proc.new{|record| record.step == "checkout"}

    # cc fields as accessors so we don't store anything bad.
    attr_accessor :card_type, :card_expiration_month, :card_expiration_year, :card_number, :card_verification_value, :step

    # Process the payment
    def process
      self.processed_at = Time.now
      begin
        process_payment
      rescue => e
        logger.error("reservation #{self.confirmation_number} failed with error message #{e} ")
        self.error_message = "#{e}"
        self.status = 7  #failed
      end
      save!
      self.status == 1

    end

    protected

      def process_payment

       # this forces the system to use the testing server, which is what all dev accounts use.
       ActiveMerchant::Billing::Base.mode = :test if RAILS_ENV != "production"

       # read api key and  transaction # from config file
      c = YAML::load(File.open("#{RAILS_ROOT}/config/config.yml")) 
      user = c[RAILS_ENV]['auth_net_user']
      pass = c[RAILS_ENV]['auth_net_pass']

       creditcard = ActiveMerchant::Billing::CreditCard.new(
         :first_name => self.user.first_name,
         :last_name => self.user.last_name,
         :number=> self.card_number,
         :verification_value =>card_verification_value,
         :type => self.card_type,
         :month => self.card_expiration_month,
         :year => self.card_expiration_year
       )

       if creditcard.valid?
           options = {:name => self.user.full_name,
              :email => self.user.email,
              :phone => self.phone_number,
          :card_code => self.card_verification_value,
               :order_id => self.confirmation_number,
          :description => "Conference reservation",
               :billing_address=>{
                 :address1 => self.billing_address,
                 :city => self.billing_city,
                 :state => self.billing_state,
                 :zip => self.billing_zip,
                 :country => "US"}
               }

           



                gateway = AuthorizeNetGateway.new({:login => user, :password=>pass})


             response = gateway.purchase(self.total_cost_in_cents, creditcard, options)

             if response.success?
               self.status = 1
               self.confirmed_at = Time.now
               self.error_message = nil
             else
               self.status = 7
               self.error_message = response.message
             end
          else
            self.status = 7

           self.error_message = "Invalid credit card."
         end


    end
  
  
end
