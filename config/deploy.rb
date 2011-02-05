require 'bundler/capistrano'
require 'config/boot'
require 'capfire/capistrano'


set :application, 'itrakt'
set :branch, 'master'
set :deploy_to, "/home/#{application}/app"

role :app, 'hosting1.80beans.net'
role :web, 'hosting1.80beans.net'
role :db,  'hosting1.80beans.net', :primary => true

ssh_options[:username] = application

set :scm, :git
set :repository, "."
set :branch, 'master'
set :deploy_via, :copy
set :copy_strategy, :export

set :use_sudo, false
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after 'deploy:update_code', 'deploy:ln_uploads'

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :ln_uploads do
    run "mkdir -p #{shared_path}/uploads && ln -s #{shared_path}/uploads #{release_path}/public/uploads"
  end

end

namespace :db do
  task :create_indexes do
    run "cd #{current_path}; rake db:mongoid:create_indexes RAILS_ENV=#{stage}"
  end
end
