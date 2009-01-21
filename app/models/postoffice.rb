class Postoffice < ActionMailer::Base
helper :application
  
  def welcome(email, extras)
      @recipients   = email[:email]
      @from         = "accounts@chartmycycles.com"
      headers         "Reply-to" => "accounts@chartmycycles.com"
      @subject      = "Welcome to ChartMyCycles"
      @sent_on      = Time.now
      @content_type = "text/html"
      body[:email] = email[:email]  
      body[:authorization] = email[:authorization]  
      body[:creditcard] = email[:creditcard]
      body[:first_name] = extras[:first_name]
      body[:last_name] = extras[:last_name]
    end
end
