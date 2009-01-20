class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
#  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  ssl_required  :login, :signup

  
  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:email], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      current_user.last_login = Time.now
      current_user.save
      redirect_back_or_default(:controller => '/home', :action => 'index')
      flash[:notice] = "Logged in successfully"
    else
        flash[:notice] = "That didn't work. <br />
        Try entering your login info again."
    end
  end
  
  def contact
  end

  def benefits
  end
  
  def tour
  end
  
  def signup
    @user = User.new(params[:user])
    return unless request.post?
      if params[:terms] != '1'
        flash[:error] = "Please accept the terms of service before you proceed."      
        return
      end
########=-=-=-=-=-=-=-=-=-=-=-=-=-= Early attempt at billing code
    # BEGIN construct
    gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new({
      :login    => '358gbVPPaM4q',
      :password => '98bM2RmsYw76C34F'
    })
    # END construct
  
    # Next, construct a CreditCard object that will be charged during the
    # transaction
    # BEGIN creditcard
    creditcard = ActiveMerchant::Billing::CreditCard.new({
      :first_name => params[:first_name],
      :last_name  => params[:last_name],
      :number     => params[:credit_card_number],
      :month      => params[:month],
      :year       => params[:year],
      :verification_value => params[:verification]
    })
    # END credit_card

    # BEGIN purchase_output
    # => (TEST) The transaction was successful! The authorization is 3144302
    # END purchase_output

    # BEGIN purchase
    options = {
      :billing_address => {
        :first_name     => params[:first_name],
        :last_name      => params[:last_name],
        :address1 => '20178 Lora Lane',
        :city     => 'Bend',
        :state    => 'OR',
        :country  => 'USA',
        :zip      => '97702',
        :phone    => '541-504-6929',
        :email => params[:user][:email]
      },
      :interval   => {
        :unit     => :months,
        :length   => 1
      },
      :duration   => {
        :start_date   => Time.now.to_date,
        :occurrences   => 240
      },
      :description => 'ChartMyCycles subscription'
    }

    if creditcard.valid?
      response = gateway.recurring(1300, creditcard, options)

      print "(TEST) " if response.test?

      if response.success?
        RAILS_DEFAULT_LOGGER.error("\nThe transaction was successful! The authorization is #{response.authorization}\n")
      else
        RAILS_DEFAULT_LOGGER.error(response.message.to_s)
        flash[:error] = "The credit card information didn't work. Try again."
        
        return 
      end
    else
      RAILS_DEFAULT_LOGGER.error("\nThe credit card is invalid\n")
      flash[:error] = "The credit card is invalid. Please try again."
      return
    end
    # END purchase
#######=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    @user.last_login = Time.now
    @user.subscription_info = SubscriptionInfo.new
    @user.subscription_info.authorization = response.authorization
    @user.subscription_info.message = response.message
    @user.subscription_info.save
    @user.save!
    self.current_user = @user
    c = Cycle.new
    c.user = @user
    c.started = Time.now
    c.save
    redirect_back_or_default(:controller => '/home', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
    Postoffice.deliver_welcome(@user.email)
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You've been logged out."
    redirect_back_or_default(:controller => '/account', :action => 'login')
  end
end
