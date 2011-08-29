class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User)
        rails_admin_dashboard_path 
    end
  end
  
  # def after_sign_out_path_for(resource_or_scope)
  #   root_path
  # end

  def current_user
     if params[:auth_token]
       @user ||= User.where(:authentication_token => params[:auth_token]).first
       puts ("PAS PASSS  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" + @user.password.to_s)
       puts ("USER  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" + User.where(:authentication_token => params[:auth_token]).first.inspect)
     else
       super
     end
  end
end
