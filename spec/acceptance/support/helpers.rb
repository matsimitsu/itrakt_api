module HelperMethods

  def current_path
    URI.parse(current_url).path
  end

  def accept_confirm(page)
    page.execute_script('window.confirm = function() { return true; }')
  end

end

Rspec.configuration.include(HelperMethods)
