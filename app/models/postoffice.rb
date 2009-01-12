class Postoffice < ActionMailer::Base
  
  def welcome(email)
      @recipients   = email
      @from         = "accounts@chartmycycles.com"
      headers         "Reply-to" => "accounts@chartmycycles.com"
      @subject      = "Welcome to ChartMyCycles"
      @sent_on      = Time.now
      @content_type = "text/html"
      body[:email] = email    
    end
end
