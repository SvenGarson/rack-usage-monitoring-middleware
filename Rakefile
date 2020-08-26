res = require_relative 'lib/rack_usage_monitoring_middleware'

desc('Run middleware tests')
task(:test_middle) do
  system('clear')
  Dir.glob('test/middleware/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("bundle exec ruby #{file_name}")
  end
end

res = require_relative 'lib/rack_usage_monitoring_middleware'
desc('Run helper tests')
task(:test_helper) do
  system('clear')
  Dir.glob('test/helpers/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("bundle exec ruby #{file_name}")
  end
end