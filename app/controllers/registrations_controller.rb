class RegistrationsController < Devise::RegistrationsController  
  protect_from_forgery :except => [:create, :edit]
  prepend_view_path "app/views/devise"
  
  def new
    redirect_to(root_path)
  end
  
  def create
    build_resource
    resource.email = params[:email]
    resource.username = params[:username]
    resource.source = params[:source]
    resource.report_day = params[:report_day].to_i
    resource.safari_enabled = params[:safari_enabled]
    if params[:source] == 'iphone' 
      if params[:safari_changed_time].present?
        if params[:safari_changed_time].class == String
          params[:safari_changed_time] = Time.parse(params[:safari_changed_time])
        end
      end
    else
      params[:safari_changed_time] = Time.now
    end
    resource.safari_changed_time = params[:safari_changed_time]
    if params[:password].present?
      puts ('PASWRORD PRESENT 00000000000000000000000000000000000000000000000000000000000000000')
      resource.password = params[:password]
    else
      resource.password = SecureRandom.base64(10)
    end

    puts ('PASSWORD 00000000000000000000000000000000000000000000000000000000000000000')
    puts (resource.inspect)
    puts (resource.password)
    
    if resource.save!
      sign_in(resource_name, resource)
      puts ('--------------------------------------------------')
      puts (current_user.inspect)
      # current_user.send_welcome_email

      #Storing mobile's installed apps
      mobile_apps = Array.new
      if params[:mobile_apps].present?
        mobile_apps = params[:mobile_apps]        

        mobile_apps.each do |mobile_app|
          # app = Hash.new
          current_user.mobileapps.create({:app_name => mobile_app[:app_name], :package_name => mobile_app[:package_name], :deleted => mobile_app[:deleted], :sent_email => false})
        end
      end
      
      
      #Adding Partners
      new_partners = Array.new
      if params[:partners].present?
        new_partners = params[:partners].split(',').map{|email| email.to_s}        
      end
      
      new_partners.each do |partner_email|
        partner = Partner.all(:conditions => {:email => partner_email.to_s})

        if partner.present?
          # Partner email is already present
          current_user.partners << partner
          current_user.save!
        else
          # Partner email is NOT present, create NEW
          current_user.partners.create({:email => partner_email.to_s})
        end
        current_user.send_invitation_to_partner(partner_email.to_s)
      end
      
      current_user.mark_all_mobileapps_as_reported(current_user)
    end
    
    respond_to do |format|
      format.html { redirect_to(home_index_url)}
      format.xml  { render :xml => {:user => current_user.serializable_hash.merge(:auth_token => form_authenticity_token).merge(:partners => current_user.partners.map{|p| {p.email => p.id}}.inject(:merge))}}
      format.json { render :json => {:user => current_user.serializable_hash.merge(:auth_token => form_authenticity_token).merge(:partners => current_user.partners.map{|p| {p.email => p.id}}.inject(:merge))}}
    end
  end
  
end  


