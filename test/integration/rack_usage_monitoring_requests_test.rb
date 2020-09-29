require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageMonitoringRequestsTest < Minitest::Test
  def test_that_RackUsageMonitoring_UsageDataProtected_requests_returns_instance_of_TrackerRequest
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    usage_data_protected = middleware_wrapper.usage_data_protected

    tracker_request = usage_data_protected.requests

    assert_instance_of(RackUsageTracking::TrackerRequest, tracker_request)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_requests_total_returns_expected_integer
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)
    
    37.times do |_|
      mock_request.get('')
    end

    usage_data_protected = middleware_wrapper.usage_data_protected
    tracker_request = usage_data_protected.requests
    total_requests = tracker_request.total

    assert_instance_of(Integer, total_requests)
    assert_equal(37, total_requests)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_requests_today_returns_expected_integer
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)
    
    # before any request received
    tracker_request = middleware_wrapper.usage_data_protected.requests
    requests_before_any_requests = tracker_request.today

    # requests first day
    base_date = Date.today
    RackUsageUtils::OverrideableDate.set_today_date(base_date)
    100.times do |_|
      mock_request.get('')
    end

    tracker_request = middleware_wrapper.usage_data_protected.requests
    requests_first_day = tracker_request.today

    # requests second day
    RackUsageUtils::OverrideableDate.set_today_date(base_date + 1)
    255.times do |_|
      mock_request.get('')
    end

    tracker_request = middleware_wrapper.usage_data_protected.requests
    requests_second_day = tracker_request.today
    
    assert_equal(0, requests_before_any_requests)
    assert_equal(100, requests_first_day)
    assert_equal(255, requests_second_day)
  end
end
