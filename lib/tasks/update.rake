
namespace :update do
  task :tvdb => :environment do
    TvdbUpdate.fetch_and_run
  end

  task :shows => :environment do
    Show.update_outdated
  end

  task :trending => :environment do
    Rails.cache.write("trending", Trakt::Show::Trending.new.enriched_results.to_json, :expires_in => 5.minutes)
  end

  task :fetch_episodes => :environment do
    Show.fetch_episodes
  end

end
