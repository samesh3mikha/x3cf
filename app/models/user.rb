require 'smtp_api_header'  

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :username, :password_confirmation, :remember_me, :report_day, :safari_enabled, :safari_changed_time
  
  has_and_belongs_to_many :partners
  has_many :report_logs
  has_many :weblogs 
  has_many :mobileapps
  before_save :ensure_authentication_token    
  validates :email, :presence =>  true
  
  # This method is called when notification from sendGrid is received.
  def update_report_log(partner_email, report_ids, status) 
   pid = Partner.find_by_email("#{partner_email}").id
   
   reportlogs = self.report_logs.where(:partner_id => pid, :id => report_ids)
   puts ("+++++++++++++++++++++++++++++++ REPORT LIST ALL")
   puts (reportlogs.inspect)
   if reportlogs.present?
     reportlogs.first.update_attributes(:email_status =>  "#{status}")
   end   
  end
 
  #Sends welcome email to user on sign up  # NOT IMPLEMENTED RIGHT NOW
  def send_welcome_email
    hdr = SmtpApiHeader.new()  
    hdr.addTo(self.email) 
    hdr.setUniqueArgs({"email_type" => "welcome"})
  
    Emailer.send_welcome_email_to_user(self.email, hdr.asJSON()).deliver
  end
  
  #Sends invitations email all the partners of current user
  def send_invitations_to_all_partners
    receiver = []
    partners_id =[]
    x3user =  User.find(self.id) 
    x3user.partners.all.each do |p|
      send_invitation_to_partner(p.email)
    end
    
    self.mark_all_mobileapps_as_reported(x3user)
  end
    
  #Sends invitation email to certain partner
  def send_invitation_to_partner(email)
    hdr = SmtpApiHeader.new()  
    hdr.addTo(email) 
    hdr.setUniqueArgs({"email_type" => "invitation"})

    Emailer.send_invitation_email_to_partner(email, self, hdr.asJSON()).deliver 
  end  
    
  #Sends removed notification email to certain partner
  def send_user_removed_notification_to_partner(email)
    hdr = SmtpApiHeader.new()  
    hdr.addTo(email) 
    hdr.setUniqueArgs({"email_type" => "remove_note"})

    Emailer.send_user_removed_email_to_partner(email, self, hdr.asJSON()).deliver 
  end  
  
  
  #Sends welcome email to user on sign up
  def send_settings_changed_notification_to_all_partners
    receiver = []
    partners_id =[]
    x3user =  User.find(self.id) 
    x3user.partners.all.each do |p|
      send_settings_changed_notification_to_partner(p.email)
    end
  end
  
  #Sends welcome email to user on sign up
  def send_settings_changed_notification_to_partner(email)
      hdr = SmtpApiHeader.new()  
      hdr.addTo(email) 
      hdr.setUniqueArgs({"email_type" => "settings_changed"})

      Emailer.send_setting_changed_email_to_partner(email, self, hdr.asJSON()).deliver
  end

  
  # This method is called via Rufu-scheduler. It gathers all the users and send email to their respective partners.
  def self.collect_xusers_and_send_email_to_accountable_partners 
    users = []  
    stime = 1.hour.ago.hour
    etime = Time.now.hour  
    # Collect all the users whose report sending duration fall within given instance of 1 hour ( ie. between stime and etime)
    self.find_each(:batch_size => 500) do |usr| 
      users << usr.id if (Time.now.hour == usr.created_at.hour and usr.report_day == (Time.now.wday + 1))
    end 
    
    puts ("+++++++++++++++++++++++++++++++++++++++++++++++++++")
    puts (users.count)
    # Send email to the accountable partners of each user.
    users.each do |uid| 
      send_report_to_all_partners(uid)
    end 
  end
  
  
  # This method collects all the accountable partners of a user and send them emails.
  def send_report_to_all_partners(usr_id) 
    receiver = []
    partners_id =[]
    x3user =  User.find(usr_id) 
    x3user.partners.all.each do |p|
      receiver << p.email
      partners_id << p.id
    end

    if receiver.present?
      # Log the email status as 'pending' in 'report_logs' table
      report_ids = []
      logged_date = Time.new.utc
      report_logs_created = partners_id.each { |id| 
        report_log = x3user.report_logs.create!(:email_status => 'pending', :partner_id => id, :created_at => logged_date) 
        report_ids<<report_log.id
      }      
      # logged_date = x3user.report_logs.last.created_at
      puts ("+++++++++++++++++++++++++++++++ LOG CREATED DATE")
      puts (report_ids)

      # Get the weblogs to be reported
      latest_sent_date = ""
      weblogs = []
      reports_of_a_partner = x3user.report_logs.where("partner_id = ?", partners_id[0])
      if reports_of_a_partner.present?     
        if reports_of_a_partner.count == 1
          latest_sent_date = reports_of_a_partner.last.created_at.utc
          weblogs = x3user.weblogs.collect { |weblog| weblog if (weblog.created_at.utc < latest_sent_date and weblog.porn == true) }
        elsif reports_of_a_partner.count > 1
          latest_sent_date = reports_of_a_partner.last.created_at.utc
          second_latest_sent_date = reports_of_a_partner[reports_of_a_partner.count - 2].created_at.utc

          weblogs = x3user.weblogs.collect { |weblog| weblog if (weblog.created_at.utc > second_latest_sent_date and weblog.created_at.utc < latest_sent_date and weblog.porn == true) }
        end
      end
      puts ('++++++++++++++++++++++++++++++++++++++   WEBLOGS')
      puts (weblogs.inspect)
      if weblogs.present?
        weblogs.compact!
      end

      installed_apps = Array.new
      uninstalled_apps = Array.new
      installed_apps = Mobileapp.where("user_id = ? AND sent_email = ? And deleted = ?", x3user.id, false, false )
      uninstalled_apps = Mobileapp.where("user_id = ? AND sent_email = ? And deleted = ?", x3user.id, false, true )      
      
      # Generate Email Header 
      hdr = SmtpApiHeader.new()  
      hdr.addTo(receiver)
      unique_args = {"user_id" => "#{x3user.id}", "report_ids" => "#{report_ids}", "email_type" => "report"} 
      hdr.setUniqueArgs(unique_args)

      # Send the emails  to all the accountable partners
      Emailer.send_report_email_to_all_partners(receiver, self, weblogs,  installed_apps, uninstalled_apps, hdr.asJSON()).deliver   
      puts ":::::::: Emails sent!!"
      
      #Mark all apps as reported
      mark_all_mobileapps_as_reported(x3user)
    end
  end
  
  def mark_all_mobileapps_as_reported(user)
    user.mobileapps.each do |mobileapp|
      mobileapp.sent_email = true
      mobileapp.save!
    end
  end
      
end        

  

# ---------------------
# SendGrid Email Status
# ---------------------
# Processed    : Message has been received and is ready to be delivered.
# Dropped      : Recipient exists in one or more of your Suppression Lists: Bounces, Spam Reports, Unsubscribes.
# Delivered    : Message has been successfully delivered to the receiving server.
# Deferred     : Recipient’s email server temporarily rejected message. Refer to our article on throttling.
# Bounce       : Receiving server could not or would not accept message.
# Open         : Recipient has opened the HTML message.
# Click        : Recipient clicked on a link within the message.
# Spam Report  : Recipient marked message as spam.
# Unsubscribe  : Recipient clicked on messages’s unsubscribe link. 