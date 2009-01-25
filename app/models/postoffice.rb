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

  def newpost(email)
    @recipients   = email[:email]
    @from         = "accounts@chartmycycles.com"
    headers         "Reply-to" => "accounts@chartmycycles.com"
    @subject      = "[ChartMyCycles] " + email[:title]
    @sent_on      = Time.now
    @content_type = "text/html"
    body[:email] = email[:email]  
    body[:body] = email[:body]  
    body[:id] = email[:id]
    body[:title] = email[:title]
    body[:topic] = email[:topic]
  end
  
  def newabout(email)
    @recipients   = email[:email]
    @from         = "accounts@chartmycycles.com"
    headers         "Reply-to" => "accounts@chartmycycles.com"
    @subject      = "[ChartMyCycles] Your forum introduction"
    @sent_on      = Time.now
    @content_type = "text/html"
    body[:email] = email[:email]  
    body[:body] = email[:body]  
    body[:id] = email[:id]
end
end
