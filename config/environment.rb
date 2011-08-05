# require 'yaml'
# YAML::ENGINE.yamler = 'syck'

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
X3watchRails::Application.initialize!

AlchemyApi.api_key = "4f9d9541a7e0ebf661c97852d228f5ab839109bb"