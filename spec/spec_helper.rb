ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')
require File.expand_path(File.dirname(__FILE__) + "/blueprints")
require 'rspec/autorun'
require 'rspec/rails'
require 'email_spec'
require File.expand_path(File.dirname(__FILE__) + "/mongoid_helpers")

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)

  drop_collections(get_mongoid_models)
  ::Rails::Mongoid.index_children(get_mongoid_models)

  config.before :each do
    I18n.locale = :nl
    empty_collections(get_mongoid_models)
  end

  config.before :all do
    init_repo
  end

  config.after :all do
    delete_repo
    delete_preview
    delete_delivery
  end
end

def stub_image(filename='design.jpg')
  File.join(Rails.root, 'spec/images', filename)
end

def init_repo
  `mkdir -p #{REPO_PATH}`
  `cd #{REPO_PATH}; git init`
end

def delete_repo
  `rm -rf #{REPO_PATH}`
end

def delete_preview
  `rm -rf #{PREVIEW_PATH}`
end

def delete_delivery
  `rm -rf #{DELIVERY_PATH}`
end
