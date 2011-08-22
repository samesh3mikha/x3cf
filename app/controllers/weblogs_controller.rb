class WeblogsController < ApplicationController
  protect_from_forgery :except => [:weblog_checked_notification]
  before_filter :require_login, :except => [:weblog_checked_notification]
  def create
    puts ('++++++++++++++++++++++++++++++ CREATING WEBLOG')
    
    params[:weblog][:porn] = "not_checked"
    respond_to do |format|
      weblog = current_user.weblogs.create(params[:weblog])
      if weblog.present?
        unchecked_weblogs = Weblog.find(:all, :conditions =>['porn = ?', 'not_checked'], :order => "created_at ASC", :limit => 3)
        if unchecked_weblogs.count == 3
          # SEND the weblogs to CF
          Weblog.checkIfPorn(unchecked_weblogs)          
        end

        format.html { redirect_to(home_index_url)}
        format.xml  { render :xml => {'success'=> params[:weblog][:source_id] }}
        format.json { render :json => {'success'=> params[:weblog][:source_id] } }
      else
        format.html { redirect_to(home_index_url)}
        format.xml  { render :xml => {'error'=> params[:weblog][:source_id] } }
        format.json { render :json => {'error'=> params[:weblog][:source_id] } }
      end
    end
  end
  
  def weblog_checked_notification
    puts ("params")
    puts (params[:final_outputs].who-would-consider-this-porn)

    weblog = Weblog.find(params[:meta_data].to_i)
    weblog.porn = params[:final_outputs].who-would-consider-this-porn
    weblog.save!

    puts(weblog.inspect)
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