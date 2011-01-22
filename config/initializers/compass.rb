require 'compass'
require 'compass/app_integration/rails'
Compass::AppIntegration::Rails.initialize!
Haml::Template.options[:attr_wrapper] = '"'
