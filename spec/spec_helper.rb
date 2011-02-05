ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')
require File.expand_path(File.dirname(__FILE__) + "/blueprints")
require 'rspec/autorun'
require 'rspec/rails'
require File.expand_path(File.dirname(__FILE__) + "/mongoid_helpers")

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  drop_collections(get_mongoid_models)
  ::Rails::Mongoid.index_children(get_mongoid_models)

  config.before :each do
    I18n.locale = :nl
    empty_collections(get_mongoid_models)
  end

end

def stub_image(filename='design.jpg')
  File.join(Rails.root, 'spec/images', filename)
end


def tvdb_show
  @show ||= Show.create_from_tvdb_id('82438')
end

def another_tvdb_show
  @another_show ||= Show.create_from_tvdb_id('82066')
end