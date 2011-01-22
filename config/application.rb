require File.expand_path('../boot', __FILE__)

require 'mongoid/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_resource/railtie'
require 'rails/test_unit/railtie'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Itrakt
  class Application < Rails::Application
    config.time_zone = 'Amsterdam'

    config.i18n.default_locale = :nl

    config.generators do |g|
      g.orm             :mongoid
      g.template_engine :haml
      g.test_framework  :rspec, :fixture => false
    end

    config.encoding = 'utf-8'

    config.filter_parameters += [:password, :password_confirmation]

    config.active_support.deprecation = :log

    config.action_mailer.delivery_method   = :postmark
    config.action_mailer.postmark_settings = {:api_key => '9fee03c4-7440-440d-ba23-d2708b20c815'}
  end
end
