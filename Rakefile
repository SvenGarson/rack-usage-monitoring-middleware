require_relative 'lib/rack_usage_monitoring_middleware'

# set RACK_ENV to development when running tests
# DRY running tests in folder
# how will this middleware be used?
#
# do not touch the RACK_ENV apart from running tests in order to have the Host
# be able to set the mode to production and the programmer to set his own flags.
# That correct?
#
# Use platform independent way of building directories
# Use absolute directories where necessary

def run_tests_in_test_sub_directory_in_development_mode(sub_folder_name)
  Dir.glob('test/middleware/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby #{file_name}")
  end
end

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

desc('Run tracking tests')
task(:test_tracking) do
  Dir.glob('test/tracking/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby #{file_name}")
  end
end

desc('Run test helpers tests')
task(:test_test_helpers) do
  Dir.glob('test/test_helpers/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby #{file_name}")
  end
end

desc('Run integration tests')
task(:test_integration) do
  Dir.glob('test/integration/*_test.rb').each do |file_name|
    # make this absolute and DRY
    system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby #{file_name}")
  end
end

desc('Run current test suite')
task(:test_current) do
  system("RACK_ENV=#{RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT} bundle exec ruby test/integration/rack_usage_monitoring_query_parameters_test.rb")
end

desc('Run all tests')
task :test_all => [:test_middle, :test_helper, :test_attribs, :test_utils, :test_tracking, :test_test_helpers, :test_integration] do; end