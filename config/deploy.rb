require 'bundler/capistrano'
require 'config/boot'

set :application, 'itrakt'
set :branch, 'master'
set :deploy_to, "/home/#{application}/app"

role :app, 'hosting1.80beans.net'
role :web, 'hosting1.80beans.net'
role :db,  'hosting1.80beans.net', :primary => true

ssh_options[:username] = application

set :scm, :git
set :repository, "git@github.com:matsimitsu/itrakt_api.git"
set :deploy_via, :remote_cache
set :use_sudo, false
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

end

namespace :db do
  task :create_indexes do
    run "cd #{current_path}; rake db:mongoid:create_indexes RAILS_ENV=#{stage}"
  end
end
