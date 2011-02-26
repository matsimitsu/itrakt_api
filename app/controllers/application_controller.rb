class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :ping_gauges

  def ping_gauges
    url = 'http://gaug.es/track?'
    url << "h[site_id]=#{GAUGES_SITE_ID}&"
    url << "h[title]=#{controller_name}-#{action_name}&"
    url << "h[resource]=#{CGI::escape request.url}&"
    url << "h[user_agent]=#{CGI::escape request.user_agent}&"
    url << "h[unique]=1"
    HTTPI.get(url)
  end

  def external_url(url)
    return unless url
    url_for(root_url.chop + url)
  end

  protected
    def set_username_and_password
      authenticate_with_http_basic do |user_name, password|
        @username, @password = user_name, password
      end
      render :status => :unauthorized, :text => nil unless @username && @password
    end

    def in_admin?
      request.path.starts_with?('/admin')
    end

    def authenticate_admin
      unless %w{test development}.include? Rails.env
        authenticate_or_request_with_http_basic do |username, password|
          username == 'admin' && password == 'z'
        end
      end
    end

end
