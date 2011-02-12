
namespace :update do
  task :tvdb => :environment do
    TvdbUpdate.fetch_and_run
  end

  task :trending => :environment do
    Rails.cache.write("trending", Trakt::Show::Trending.new.enriched_results.to_json, :expires_in => 5.minutes)
  end

end
