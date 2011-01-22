class ApplicationController < ActionController::Base

  protect_from_forgery

  def external_url(url)
    return unless url
    url_for(root_url.chop + url)
  end

  protected



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
