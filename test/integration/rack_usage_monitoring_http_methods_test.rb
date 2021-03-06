require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageMonitoringHttpMethodsTest < Minitest::Test
  def test_that_RackUsageMonitoring_UsageDataProtected_http_methods_returns_instance_of_TrackerHttpMethod
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper

    tracker_http_method = middleware_wrapper.usage_data_protected.http_methods

    assert_instance_of(RackUsageTracking::TrackerHttpMethod, tracker_http_method)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_http_methods_least_frequent_returns_expected_http_method_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    3.times { |_| mock_request.get('/') }
    7.times { |_| mock_request.put('/') }
    11.times { |_| mock_request.post('/') }
    3.times { |_| mock_request.options('/') }

    tracker_http_method = middleware_wrapper.usage_data_protected.http_methods
    least_frequent_methods = tracker_http_method.least_frequent
    least_frequent_methods_count = least_frequent_methods.size

    assert_equal(2, least_frequent_methods_count)
    assert_includes(least_frequent_methods, 'GET')
    assert_includes(least_frequent_methods, 'OPTIONS')
    refute_includes(least_frequent_methods, 'PUT')
    refute_includes(least_frequent_methods, 'POST')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_http_methods_most_frequent_returns_expected_http_method_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    5.times { |_| mock_request.get('/') }
    11.times { |_| mock_request.put('/') }
    11.times { |_| mock_request.post('/') }
    9.times { |_| mock_request.options('/') }

    tracker_http_method = middleware_wrapper.usage_data_protected.http_methods
    most_frequent_methods = tracker_http_method.most_frequent
    most_frequent_methods_count = most_frequent_methods.size

    assert_equal(2, most_frequent_methods_count)
    assert_includes(most_frequent_methods, 'PUT')
    assert_includes(most_frequent_methods, 'POST')
    refute_includes(most_frequent_methods, 'GET')
    refute_includes(most_frequent_methods, 'OPTIONS')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_http_methods_all_returns_expected_http_method_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    5.times { |_| mock_request.get('/') }
    6.times { |_| mock_request.put('/') }
    17.times { |_| mock_request.post('/') }
    9.times { |_| mock_request.options('/') }

    tracker_http_method = middleware_wrapper.usage_data_protected.http_methods
    all_methods = tracker_http_method.all
    all_methods_count = all_methods.size

    assert_equal(4, all_methods_count)
    assert_includes(all_methods, 'GET')
    assert_includes(all_methods, 'PUT')
    assert_includes(all_methods, 'POST')
    assert_includes(all_methods, 'OPTIONS')
  end
end
