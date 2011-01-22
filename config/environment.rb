# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Itrakt::Application.initialize!

Sass::Plugin.options = {:style => :expanded, :line_comments => false}

Haml::Template.options = {:ugly => false, :format => :html5, :attr_wrapper => '"'}