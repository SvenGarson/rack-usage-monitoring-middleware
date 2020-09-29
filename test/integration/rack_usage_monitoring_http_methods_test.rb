require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageMonitoringRequestsTest < Minitest::Test
  def test_that_RackUsageMonitoring_UsageDataProtected_http_methods_returns_instance_of_TrackerHttpMethod
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    tracker_http_method = middleware_wrapper.usage_data_protected.http_methods

    assert_instance_of(RackUsageTracking::TrackerHttpMethod, tracker_http_method)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_http_methods_least_frequent_returns_expected_http_method_strings
    skip
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    # figure out how to properly MockRequest with a specific Http Version ??? !!!

    tracker_http_method = middleware_wrapper.usage_data_protected.http_methods

    #assert_instance_of(RackUsageTracking::TrackerHttpMethod, tracker_http_method)
  end

  #least_frequent returns expected least frequent http method string

=begin

  def test_that_RackUsageMonitoring_UsageDataProtected_http_methods_total_returns_expected_integer
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)
    
    37.times do |_|
      mock_request.get('')
    end

    usage_data_protected = middleware_wrapper.usage_data_protected
    tracker_http_method = usage_data_protected.http_methods
    total_http_methods = tracker_http_method.total

    assert_instance_of(Integer, total_http_methods)
    assert_equal(37, total_http_methods)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_http_methods_today_returns_expected_integer
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)
    
    # before any request received
    tracker_http_method = middleware_wrapper.usage_data_protected.http_methods
    http_methods_before_any_http_methods = tracker_http_method.today

    # http_methods first day
    base_date = Date.today
    RackUsageUtils::OverrideableDate.set_today_date(base_date)
    100.times do |_|
      mock_request.get('')
    end

    tracker_http_method = middleware_wrapper.usage_data_protected.http_methods
    http_methods_first_day = tracker_http_method.today

    # http_methods second day
    RackUsageUtils::OverrideableDate.set_today_date(base_date + 1)
    255.times do |_|
      mock_request.get('')
    end

    tracker_http_method = middleware_wrapper.usage_data_protected.http_methods
    http_methods_second_day = tracker_http_method.today
    
    assert_equal(0, http_methods_before_any_http_methods)
    assert_equal(100, http_methods_first_day)
    assert_equal(255, http_methods_second_day)
  end
=end
end

=begin
  Tests to run for TrackerHttpMethod:
  - usage data returns instance of TrackerHttpMethod
  - #least_frequent returns expected least frequent http method string
  - #most_frequent returns expected most frequent http method string
  - #all returns expected http method strings without duplicates

=end