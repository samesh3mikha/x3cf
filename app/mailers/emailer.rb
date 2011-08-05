class Emailer < ActionMailer::Base
 
  def send_welcome_email_to_user(recipient,sent_at = Time.now,header)
    @recipient = recipient 
    @subject = "Welcome to X3watch"
    @recipients = recipient
    @from = "X3watch@gmail.com" #TODO : Change this email 
    @sent_on = sent_at 
    @headers["X-SMTPAPI"] = header 
    content_type "text/html" 
  end
  
  def send_invitation_email_to_partner(recipient,user,sent_at = Time.now,header)
    @user = user
    @subject = "X3watch - " + user.username + ", your accountability partner, is using our service "
    @recipients = recipient
    @from = @user.email #TODO : Change this email 
    @sent_on = sent_at 
    @headers["X-SMTPAPI"] = header 
    content_type "text/html"
  end
  
  def send_user_removed_email_to_partner(recipient, user, sent_at = Time.now,header)
    @user = user
    @subject = "X3watch - " + user.username + ", your accountability partner, has removed your address from the system"
    @recipients = recipient
    @from = "X3watch@gmail.com" #TODO : Change this email 
    @sent_on = sent_at 
    @headers["X-SMTPAPI"] = header 
    content_type "text/html"
  end

  def send_setting_changed_email_to_partner(recipient, user, sent_at = Time.now,header)
    @user = user
    @subject = "X3watch - " + user.username + ", your accountability partner has changed settings"
    @recipients = recipient
    @from = "X3watch@gmail.com" #TODO : Change this email 
    @sent_on = sent_at 
    @headers["X-SMTPAPI"] = header 
    content_type "text/html"
  end
  

  def send_report_email_to_all_partners(recipient, user, weblogs,  installed_apps, uninstalled_apps, sent_at = Time.now, header)        
    @user = user
    @weblogs = weblogs
    @installed_apps = installed_apps
    @uninstalled_apps = uninstalled_apps
    @subject = "X3watch - report of " +  user.username
    @recipients = recipient
    @from = "X3watch@gmail.com" #TODO : Change this email 
    @sent_on = sent_at
    @headers["X-SMTPAPI"] = header 
    content_type "text/html"                       
  end 
    
end
