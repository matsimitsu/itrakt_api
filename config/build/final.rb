helpers do
  def some_helper(*args)
    "Helping"
  end
end

set :haml, {
  :attr_wrapper => "\"",
  :ugly => true
}

::Compass.configuration.relative_assets = true
::Compass.configuration.sass_options = {
  :style => :expanded,
  :line_comments => false,
}

configure :build do
  # activate :minify_css

  # activate :minify_javascript

  # activate :smush_pngs

  # activate :cache_buster

  # activate :ugly_haml
end
