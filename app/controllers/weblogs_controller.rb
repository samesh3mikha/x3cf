class WeblogsController < ApplicationController
  protect_from_forgery :except => [:weblog_checked_notification]
  before_filter :require_login, :except => [:weblog_checked_notification]
  def create
    puts ('++++++++++++++++++++++++++++++ CREATING WEBLOG')
    # if params[:weblog][:source] == "iphone"
    #   params[:weblog][:porn] = true
    # else
      params[:weblog][:porn] = false
      if Weblog.checkIfPorn(params[:weblog][:url])
        params[:weblog][:porn] = true
      end      
    # end

    
    respond_to do |format|
      if current_user.weblogs.create(params[:weblog])
        puts (params[:weblog][:source_id])
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