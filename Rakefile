require_relative 'lib/rack_usage_monitoring_middleware'

desc('Run middleware tests')
task(:test_middle) do
  Dir.glob('test/middleware/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby #{file_name}")
  end
end

desc('Run helper tests')
task(:test_helper) do  
  Dir.glob('test/helpers/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby #{file_name}")
  end
end

desc('Run attributes tests')
task(:test_attribs) do
  Dir.glob('test/attributes/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby #{file_name}")
  end
end

desc('Run utils tests')
task(:test_utils) do
  Dir.glob('test/utils/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby #{file_name}")
  end
end

desc('Run current test-suit')
task(:test_current) do
  system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby test/attributes/rack_usage_attributes_attribute_string_length_test.rb")
end

desc('Run all tests')
task :test_all => [:test_middle, :test_helper, :test_attribs, :test_utils] do; end