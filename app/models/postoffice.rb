class Postoffice < ActionMailer::Base
helper :application
  
  def welcome(email, options)
      @recipients   = email[:user]
      @from         = "accounts@chartmycycles.com"
      headers         "Reply-to" => "accounts@chartmycycles.com"
      @subject      = "Welcome to ChartMyCycles"
      @sent_on      = Time.now
      @content_type = "text/html"
      body[:email] = email[:user]  
      body[:authorization] = email[:authorization]  
      body[:creditcard] = email[:creditcard]
      body[:first_name] = options[:first_name]
      body[:last_name] = options[:last_name]
    end
end
