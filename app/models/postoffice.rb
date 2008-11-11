class Postoffice < ActionMailer::Base
  
  def welcome(email)
      @recipients   = email
      @from         = "billing@chartmycycles.com"
      headers         "Reply-to" => "billing@chartmycycles.com"
      @subject      = "Welcome to ChartMyCycles"
      @sent_on      = Time.now
      @content_type = "text/html"
      body[:email] = email       
    end
end
