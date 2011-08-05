
class UsersController < ApplicationController
  before_filter :require_login

  def update
    if params[:sync] = 0
       current_user.email = params[:email]
       current_user.username = params[:username]
       current_user.reportduration = params[:reportduration].to_i
       current_user.safari_enabled = params[:safari_enabled]
       if current_user.save
         current_user.send_settings_changed_notification_to_all_partners  
       end

       #Current Partners
       current_partners = current_user.partners.map{|partner| partner.email}

       #New Partners
       new_partners = Array.new
       new_partners = params[:partners].split(',').map{|email| email.to_s}

       #Removed partners
       removed_partners = current_partners - new_partners
       removed_partners.each do |partner_email|
         partner = Partner.first(:conditions => {:email => partner_email.to_s})
         if partner.users.count == 0

         elsif partner.users.count == 1
           current_user.partners.delete(partner)
           current_user.send_user_removed_notification_to_partner(partner_email.to_s)
           partner.destroy             
         elsif partner.users.count > 1
           current_user.partners.delete(partner)
           current_user.send_user_removed_notification_to_partner(partner_email.to_s)
         end
       end

       #Added partners
       added_partners = new_partners - current_partners
       added_partners.each do |partner_email|
         partner = Partner.first(:conditions => {:email => partner_email.to_s})

         if partner.present?
           # Partner email is already present
           current_user.partners << partner
         else
           # Partner email is NOT present, create NEW
           current_user.partners.create({:email => partner_email.to_s})
         end
         current_user.send_invitation_to_partner(partner_email.to_s)
      end
    else
      puts ("Syncing ------------------------------------------------------------ ")
      puts(current_user.inspect)
    end
  
    respond_to do |format|
     format.html { redirect_to(home_index_url)}
     format.xml  { render :xml => {:user => current_user.serializable_hash.merge(:auth_token => form_authenticity_token).merge(:partners => current_user.partners.map{|p| {p.email => p.id}}.inject(:merge))}}
     format.json { render :json => {:user => current_user.serializable_hash.merge(:auth_token => form_authenticity_token).merge(:partners => current_user.partners.map{|p| {p.email => p.id}}.inject(:merge))}}
    end
  end
  
  def store_mobileapps
    #Storing mobile's installed apps
    mobile_apps = Array.new
    if params[:mobile_apps].present?
      mobile_apps = params[:mobile_apps]        
      
      mobile_apps.each do |mobile_app|
        app = Mobileapp.where("user_id = ? AND package_name = ?", current_user.id, mobile_app[:package_name]).first
        if !app.present?
          current_user.mobileapps.create({:app_name => mobile_app[:app_name], :package_name => mobile_app[:package_name], :deleted => mobile_app[:deleted], :sent_email => false})
        else
          if app.deleted != mobile_app[:deleted]
            app.deleted = mobile_app[:deleted]
            if !mobile_app[:deleted]
              app.app_name = mobile_app[:app_name]
            end
            app.sent_email = false
            app.save
          end
        end        
      end
    end
    
    respond_to do |format|
      format.html { redirect_to  home_index_path }
      format.xml { render :xml => {:apps => current_user.mobileapps} }
      format.json { render :json => {:apps => current_user.mobileapps} }
    end
  end
  
  def send_reports
    current_user.send_report_to_all_partners(current_user.id)
    
    respond_to do |format|
      format.html { redirect_to  home_index_path }
      format.xml { render :xml => "Email Sent" }
      format.json { render :json => "Email Sent" }
    end
  end
  
  def send_invitations
    current_user.send_invitations_to_all_partners
    
    respond_to do |format|
      format.html { redirect_to  home_index_path }
      format.xml { render :xml => "Invitation Sent to all partners" }
      format.json { render :json => "Invitation Sent to all partners" }
    end
  end
  
  #PRIVATE METHODS
   private  

   def require_login
     if(!user_signed_in?)
       respond_to do |format|
         format.html { redirect_to  home_index_path }
         format.json { render :json => "Login required" }
       end
     end
   end
  
end
