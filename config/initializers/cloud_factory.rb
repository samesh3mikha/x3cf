# CloudFactory Initializer
require 'cf'
CF.configure do |config|
  config.api_version = "v1"
  config.api_key = "e19fe0f42883607be2f661ee3c265dc94be2514c"
  config.api_url = "http://sandbox.staging.cloudfactory.com/api/"
  config.account_name = "x3watch"
end