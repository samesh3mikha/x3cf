require 'rubygems'
require 'rufus/scheduler'

# start scheduler
scheduler = Rufus::Scheduler.start_new
 
# This job will send the email report every 1 hour.
scheduler.every("1h") do 
  puts "Colecting Users and Sending email to their accountable partners ..."   
  User.collect_xusers_and_send_email_to_accountable_partners 
end  


 