env :PATH, '/home/itrakt/app/shared/bundle/ruby/1.8/bin:/usr/local/bin:/usr/bin:$PATH'
set :output, File.join(path, 'log/cron.log')

#every 1.day, :at => '4:00 am' do
#end

every 1.day, :at => '09:03 am' do
  rake 'update:tvdb'
end

every 5.minutes do
  rake 'update:trending'
end

every 1.day, :at => '8:00 am' do
  rake 'update:shows'
end