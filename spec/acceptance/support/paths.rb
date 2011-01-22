module NavigationHelpers

  def homepage(locale=nil)
    if locale
      "/#{locale}"
    else
      '/'
    end
  end

end

Rspec.configuration.include(NavigationHelpers)
