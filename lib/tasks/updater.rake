
namespace :updater do
  task :update => :environment do
    TvdbUpdate.fetch_and_run
  end
end
