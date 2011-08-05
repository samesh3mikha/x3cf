RailsAdmin.config do |config|
  config.authorize_with do
    unless warden.user.admin?
      sign_out :user
      redirect_to new_user_session_path 
    end
  end
end

RailsAdmin.config do |config|
  # show select fields in a good order (only first 2 or 3 viewable at first)
  config.model User do
    list do
      field :id
      field :email
      field :username
      field :source
      field :admin
      field :safari_enabled
      field :reportduration
    end
  end
  config.model Partner do
    list do
      field :id
      field :email
    end
  end
  config.model ReportLog do
    list do
      field :id      
      field :user_id
      field :partner_id
      field :email_status
    end
  end 
  config.model Weblog do
    list do
      field :id      
      field :user_id      
      field :url
      field :source
      field :porn         
      field :title
      field :visited_at
    end
  end
  config.model Mobileapp do
    list do
      field :id      
      field :user_id
      field :app_name      
      field :package_name
      field :deleted
      field :sent_email
    end
  end
end