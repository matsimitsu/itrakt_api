# This configuration file works with both the Compass command line tool and within Rails.
# Require any additional compass plugins here.
require "lemonade"

project_type = :rails
project_path = Compass::AppIntegration::Rails.root
# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "public/stylesheets"
sass_dir = "public/stylesheets/sass"
environment = Compass::AppIntegration::Rails.env

asset_cache_buster do |http_path, real_path|
  if http_path =~ /images\/([^\/]+)\.png/
    Pathname.glob(File.join(File.dirname(__FILE__), '..', images_dir, $1, '*.png')).
    map { |i| i.mtime }.max.to_i.to_s
  else
    File.mtime(real_path).to_i.to_s
  end
end
