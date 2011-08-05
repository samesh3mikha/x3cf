ActionMailer::Base.smtp_settings = { 
  :address => "smtp.sendgrid.net",
  :port => "587",
  :domain => "x3watch.heroku.com", # TODO : May have to change this later
  :authentication => :plain,     
  :user_name => "prashiddha.joshi@sprout-technology.com", # my_sendgrid_username 
  :password => "sprouttechnology", # my_sendgrid_password     
  :tls => true,
}