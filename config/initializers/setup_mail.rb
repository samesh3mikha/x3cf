ActionMailer::Base.smtp_settings = { 
  :address => "smtp.sendgrid.net",
  :port => "587",
  :domain => "x3watch.heroku.com", # TODO : May have to change this later
  :authentication => :plain,     
  :user_name => "X3watch", # my_sendgrid_username 
  :password => "xxxChurch", # my_sendgrid_password     
  :tls => true,
}