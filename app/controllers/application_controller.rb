class ApplicationController < ActionController::Base

  protect_from_forgery

  def external_url(url)
    return unless url
    url_for(root_url.chop + url)
  end

  protected
    def set_username_and_password
      # TODO: Remove this when app uses http auth
      if params[:name]
        @username = params[:name]
        @password = DEFAULT_PASSWORD
        return
      end
      if params[:username] && params[:password]
        @username, @password = params[:username], params[:password]
      else
         authenticate_with_http_basic do |user_name, password|
          @username, @password = user_name, password
        end
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
