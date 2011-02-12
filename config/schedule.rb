env :PATH, '/home/itrakt/app/shared/bundle/ruby/1.8/bin:/usr/local/bin:$PATH'
set :output, File.join(path, 'log/cron.log')

#every 1.day, :at => '4:00 am' do
#end

every 6.hours do
  rake 'rake updater:update'
end
