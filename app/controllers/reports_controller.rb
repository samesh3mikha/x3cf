class ReportsController < ApplicationController  
  
  # current_user.weblogs.create(:url => '2a', :title => '2a', :visited_at => '2011-07-23 03:35:14', :source => 'iphone')
  # current_user.report_logs.create!(:email_status => 'pending', :partner_id => 1)
  before_filter :require_login, :except => [:sendgrid_event_notification]
  
  def index
    latest_sent_date = ""
    @weblogs = []
    if current_user.report_logs.present? and current_user.partners.present?
      partners_id = []
      current_user.partners.all.each do |p|
        partners_id << p.id
      end
      reports_of_a_partner = current_user.report_logs.where("partner_id = ?", partners_id[0])
      
      if reports_of_a_partner.count == 1
        latest_sent_date = reports_of_a_partner.last.created_at.utc
        @weblogs = current_user.weblogs.collect { |weblog| weblog if (weblog.created_at.utc < latest_sent_date and weblog.porn == true) }
      elsif reports_of_a_partner.count > 1
        latest_sent_date = reports_of_a_partner.last.created_at.utc
        second_latest_sent_date = reports_of_a_partner[reports_of_a_partner.count - 2].created_at.utc

        @weblogs = current_user.weblogs.collect { |weblog| weblog if (weblog.created_at.utc > second_latest_sent_date and weblog.created_at.utc < latest_sent_date and weblog.porn == true) }
      end
    end
    puts ('++++++++++++++++++++++++++++++++++++++   WEBLOGS')
    puts (@weblogs.inspect)
    
    if @weblogs.present?
      @weblogs.compact!
    end 
    @user = current_user   
  end
  
  def sendgrid_event_notification 
    puts ":::::::::  Notification received  from Sendgrid !!  ::::::::" 
    puts params

    if params[:email_type] == "report"
      user = User.find(params[:user_id])
      user.update_report_log(params[:email] , eval(params[:report_ids]), params[:event])            
    end

    render :nothing => true
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
