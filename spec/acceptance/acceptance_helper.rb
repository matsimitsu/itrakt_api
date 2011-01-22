require File.dirname(__FILE__) + "/../spec_helper"
require "steak"
require 'capybara/rails'
require 'selenium-webdriver'

Rspec.configure do |config|
  config.include Capybara
end

Capybara.default_driver = :selenium

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
