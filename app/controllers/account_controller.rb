class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
#  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
 # ssl_required  :login, :signup

  
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
    @mucus_pie = open_flash_chart_object('90%',300, '/account/mucus_pie')          
    @position_pie = open_flash_chart_object('90%',300, '/account/position_pie')          
    @bar_glass = open_flash_chart_object('100%',300, '/account/bar_glass')          
    @biggie = open_flash_chart_object('100%',300, '/account/y_right')          
  
  end
  
  def signup
    @user = User.new(params[:user])
    return unless request.post?
      if params[:terms] != '1'
        flash[:error] = "Please accept the terms of service before you proceed."      
        return
      end
=begin
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
        :address1 =>  params[:billing_address][:address],
        :city     => params[:billing_address][:city],
        :state    => params[:billing_address][:state],
        :country  => 'USA',
        :zip      => params[:billing_address][:zip],
        :phone    => params[:billing_address][:phone],
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
    if params[:coupon].length > 1
     if params[:coupon] == "YESWECAN"
      options[:trial] = {
        :amount => 0,
        :occurrences => 3
      }
      options[:duration] = {
        :start_date => Time.now.to_date + 3.months,
        :occurrences => 240
      }
      trial = 1
    else 
       flash[:error] = "That coupon code is invalid. Are you sure you entered it correctly?"
        return
     end
    end
    if creditcard.valid?
      response = gateway.recurring(900, creditcard, options)

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
=end
    @user.last_login = Time.now
#    @user.subscription_info = SubscriptionInfo.new
#    @user.subscription_info.authorization = response.authorization
#    @user.subscription_info.message = response.message
#    @user.subscription_info.save
    @user.save!
    self.current_user = @user
    c = Cycle.new
    c.user = @user
    c.started = Time.now
    c.save
    redirect_back_or_default(:controller => '/home', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
    thirtydaytrial = 1
    
    email = {
      :email => @user.email,
#      :authorization => @user.subscription_info.authorization,
#      :creditcard => params[:credit_card_number].slice(12, 16)
    }
=begin
    extras = {
       :first_name     => params[:first_name],
        :last_name      => params[:last_name],
        :address1 =>  params[:billing_address][:address],
        :city     => params[:billing_address][:city],
        :state    => params[:billing_address][:state],
        :country  => 'USA',
        :zip      => params[:billing_address][:zip],
        :phone    => params[:billing_address][:phone],
        :email => params[:user][:email]
    }
=end
    trial = 0
    if trial == 1
      Postoffice.deliver_trial(email, extras)
    elsif thirtydaytrial == 1
      Postoffice.deliver_thirtydaytrial(email)
      
    else
      Postoffice.deliver_welcome(email, extras)
    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def recent_tweets
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You've been logged out."
    redirect_back_or_default(:controller => '/account', :action => 'login')
  end
  
  
# GRAPHS FOR TAKE A TOUR PAGE

def mucus_pie
   data = []
   fertile = 5
   infertile = 15
   unsure = 8
   no_entry = 2
   data << fertile
   data << infertile
   data << unsure
   data << no_entry
 
   g = Graph.new
   g.set_bg_color('#ffffff')  
   g.pie(90, '#505050', '{font-size: 12px; color: #404040;}')
   g.pie_values(data, %w(Fertile Infertile Unsure Empty))
   g.pie_slice_colors(%w(#ffffff #0d6fc9 #cc9bff #1ebe1a))
   g.set_tool_tip("#val# of 30 entries")
   g.title("", '{font-size:18px; color: #0a5294}' )
   render :text => g.render
 end
 
 def position_pie
    data = []
    low = 18
    medium = 6
    high = 3
    no_entry = 3
    data << low
    data << medium
    data << high
    data << no_entry

    g = Graph.new
    g.set_bg_color('#ffffff')  
    g.pie(90, '#505050', '{font-size: 12px; color: #404040;}')
    g.pie_values(data, %w(Low Medium High Empty))
    g.pie_slice_colors(%w(#0d6fc9 #cc9bff #1ebe1a #ffffff))
    g.set_tool_tip("#val# of 30 entries")
    g.title("Cervical Position", '{font-size:18px; color: #0a5294}' )
    render :text => g.render
  end
  
  def bar_glass

         acne_count = 10
         cramps_count = 4
         period_count = 5
         intercourse_count = 7
         moody_count = 8
         insomnia_count = 9
         bloating_count = 6
 

     bar1 = BarGlass.new(90, '#D54C78', '#C31812')
     bar1.key('Acne', 10)

     bar2 = BarGlass.new(90, '#5E83BF', '#424581')
     bar2.key('Cramps', 10)

     bar3 = BarGlass.new(90, '#63d54c', '#424581')
     bar3.key('Period', 10)

     bar4 = BarGlass.new(90, '#d5ad4c', '#424581')
     bar4.key('Sex', 10)

     bar5 = BarGlass.new(90, '#d04cd5', '#424581')
     bar5.key('Moodiness', 10)

     bar6 = BarGlass.new(90, '#4cd5d3', '#424581')
     bar6.key('Trouble sleeping', 10)

     bar7 = BarGlass.new(90, '#d5794c', '#424581')
     bar7.key('Bloating', 10)

     1.times do |t|
             bar1.data << acne_count
             bar2.data << cramps_count
             bar3.data << period_count
             bar4.data << intercourse_count
             bar5.data << moody_count
             bar6.data << insomnia_count
             bar7.data << bloating_count



     end

     g = Graph.new
     g.set_bg_color('#ffffff')
     g.data_sets << bar1
     g.data_sets << bar2
     g.data_sets << bar3
     g.data_sets << bar4
     g.data_sets << bar5
     g.data_sets << bar6
     g.data_sets << bar7


     g.set_x_labels(%w(Trends))
     g.set_x_axis_color('#7d5f9e', '#ffffff')
     g.set_y_axis_color('#7d5f9e', '#ffffff')
     g.set_y_min(0)
     g.set_y_max(12)

     g.set_y_label_steps(12)
     g.set_y_legend("Days this cycle", 12, '#7d5f9e')
     tip = "#key#<br>#val# of 12 days"
     g.set_tool_tip(tip)
     render :text => g.render
   end
 
     def y_right
       g = Graph.new
       g.set_bg_color('#ffffff')
       cycle = Cycle.find('18')
         @user = cycle.user
      # @user = current_user
     #  cycle = @user.current_cycle
       entries = cycle.entries.find(:all, :order => 'chart_date ASC')
       max_entry = (entries.last.chart_date.to_date - cycle.started.to_date).to_i

       #Generate the amount of days in the cycle. Make the cycle 30 days long unless there are more than 30 entries.
        days = []
         if max_entry > 30
            (1..(max_entry + 1)).to_a.each do |x|
                     days << "#{x}"
                   end
         else
           (1..30).to_a.each do |x|
                 days << "#{x}"
           end
         end
         day_length = days.length

       # Create an empty array and fill it with a baseline value of 96.9 for the amount of days into the
       # cycle the latest entry exists for
       graph_array = [].fill(96.9, 0, max_entry)

       #Create an empty array for scatter point plots
       b = []

       # Now, populate that array with the actual temp values from the entries. Correspond the temp in each
       # entry to that day in the cycle.
       for entry in entries
         unless entry.temp == 0
           last_good_entry = entry.temp 
         end
         day = (entry.chart_date.to_date - cycle.started.to_date).to_i
         temperature = entry.temp
         if entry.temp == 0
           temperature = last_good_entry
           b << Point.new(day, temperature, 8)

         else 
           temperature = entry.temp
         end

         #INACURRATE TEMPS SCATTER GRAPH
         if entry.inaccurate
           b << Point.new(day, entry.temp, 8)        
         end
         graph_array[day] = temperature
       end

       # Create an empty area for a phase 2 area graph. Fill it with a baseline value of 96.9 for the amount
       # of days in the cycle.
       phase2 = [].fill(96.9, 0, day_length)
       if cycle.phase_one_end
         phase_one_end_day = (cycle.phase_one_end.to_date - cycle.started.to_date).to_i

         if cycle.phase_three_start
           phase_two_ending = (cycle.phase_three_start.to_date - cycle.started.to_date).to_i - phase_one_end_day + 1
            # Now populate the area graph for phase 2
           phase2.fill(99, phase_one_end_day, phase_two_ending)
         else

           if cycle.cover_line_entry_day
             total_entries_since_cover_line = max_entry - cycle.cover_line_entry_day + 1

             if total_entries_since_cover_line >= 3
               cover_line_temp = cycle.cover_line_entry_temp
               entry_day_temp_check = cycle.cover_line_entry_day - 1

               temp_check = []
               total_entries_since_cover_line.times do
                 if entries[entry_day_temp_check].temp - cover_line_temp >= 0.2
                   temp_check << entries[entry_day_temp_check].chart_date
                   if temp_check.length == 3
                     cycle.phase_three_start = temp_check[2].to_date
                     cycle.save
                   end 
                 else
                   temp_check.clear
                 end
                   entry_day_temp_check = entry_day_temp_check + 1
               end

             end
           else
             phase_two_end_day = (max_entry - phase_one_end_day) + 1
           end
           if cycle.phase_three_start
             phase_two_end_day = (cycle.phase_three_start.to_date - cycle.started.to_date).to_i - phase_one_end_day + 1

           else
             phase_two_end_day = (max_entry - phase_one_end_day) + 1
           end  
           phase2.fill(99, phase_one_end_day, phase_two_end_day)

         end

         # COVER LINE HLC GRAPH 

         # Make sure there are six days of entries from the beginning of phase two in
         # order to do cover line logic. User has to be into phase two before this can take place.
         # NOTE: apparently you don't have to be 6 days in to the cycle.    

     #    if  (max_entry + 1) - phase_one_end_day >= 6

           #Check to see if the cover line has been set already
           if cycle.cover_line_entry_day
             cover_line_temp = cycle.cover_line_entry_temp
             a = []
             hlc_offset = cycle.cover_line_entry_day - 7
             hlc_offset.times do
               a << Hlc.new(0, 0, 0)
             end
             6.times do
               a << Hlc.new(cover_line_temp, cover_line_temp, cover_line_temp) 
             end
           else    
           # Check to make sure that the temp has made at least a 0.2 degree 
           # jump over the highest temp of the last 6 days

           # Get the highest temp out of the last six temperatures
           cover_line_check = entries.length - 7
           the_highest_temp = entries[cover_line_check].temp
           6.times do
             if the_highest_temp <= entries[cover_line_check].temp
               the_highest_temp = entries[cover_line_check].temp
             end
             cover_line_check = cover_line_check + 1
           end



             hlc_offset = entries.length - 7 
             # Create empty hash for cover line graph coordinates
             a = []
             hlc_offset.times do
               a << Hlc.new(0, 0, 0)
             end
             if last_good_entry - the_highest_temp >= 0.2          
               cover_line_temp = the_highest_temp + 0.1
               6.times do
                 a << Hlc.new(cover_line_temp, cover_line_temp, cover_line_temp) 
               end
               cycle.cover_line_entry_day = max_entry + 1
               cycle.cover_line_entry_temp = cover_line_temp
               cycle.save            
             end          
           end
         end
    #   end    

         # End Cover Line logic.

       #This is my area graph for the phases
       if cycle.phase_one_end
         g.area_hollow(1,0,25,'#7f61a1', 'Phase two', 10)
         g.set_data(phase2)
       end

       #This is my line graph for the waking temperatures
       g.line_dot( 5, 8, '#1f76e3', 'Waking temperature', 10 )
       g.set_data(graph_array)

       #This is the scatter graph for inaccurate temps
       if b.length >= 1
         g.scatter(b, 2, '#1f76e3', 'Possible inaccurate temp', 10)
       end

       #This is the HLC graph for the cover line
       if a
         g.hlc(a, 90, 3, '#f50505', 'Cover line', 10)
       end


       g.set_y_min(96.9)
       g.set_y_max(99)
       g.set_x_axis_color('#7d5f9e', '#ffffff' )
       g.set_y_axis_color( '#7d5f9e', '#ffffff' )
       g.set_x_legend( 'Cycle days', 11, '#7d5f9e' )
       g.set_y_legend( 'Temp.', 11, '#7d5f9e' )
       g.set_x_labels(days)
       g.set_x_label_style(9, '#7d5f9e', 2, 1, '#818D9D' )
       g.set_y_label_style(9, '#7d5f9e')

       g.set_y_label_steps(21)
       tip = "Day #x_label#<br>#val# degrees"  
       g.set_tool_tip(tip)

       render :text => g.render
     end

 
 
 
 
 
end

