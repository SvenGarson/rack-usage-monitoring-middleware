require_relative 'lib/rack_usage_monitoring_middleware'

desc('Run middleware tests')
task(:test_middle) do
  puts "====== TEST-SUITE MIDDLEWARE ======\n"

  Dir.glob('test/middleware/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby #{file_name}")
  end
end

desc('Run helper tests')
task(:test_helper) do  
  puts "====== TEST-SUITE HELPERS ======\n"

  Dir.glob('test/helpers/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby #{file_name}")
  end
end

desc('Run attributes tests')
task(:test_attribs) do
  puts "====== TEST-SUITE ATTRIBUTES ======\n"

  Dir.glob('test/attributes/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby #{file_name}")
  end
end

desc('Run utils tests')
task(:test_utils) do
  puts "====== TEST-SUITE UTILS ======\n"

  Dir.glob('test/utils/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby #{file_name}")
  end
end

desc('Run all tests')
task :test_all => [:test_middle, :test_helper, :test_attribs, :test_utils] do; end