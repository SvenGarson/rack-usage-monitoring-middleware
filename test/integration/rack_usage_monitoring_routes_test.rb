require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageMonitoringRoutesTest < Minitest::Test
  def test_that_RackUsageMonitoring_UsageDataProtected_routes_returns_instance_of_TrackerRoute
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper

    tracker_route = middleware_wrapper.usage_data_protected.routes

    assert_instance_of(RackUsageTracking::TrackerRoute, tracker_route)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_routes_least_frequent_returns_expected_routes
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/path?name=Angus')
    mock_request.get('/path?')
    mock_request.get('/path?color=red')
    mock_request.get('/path?hero=SuperWoman')
    7.times do |_|
        mock_request.get('/path?metal=copper')
        mock_request.get('/path?animal=elephant')
    end

    tracker_route = middleware_wrapper.usage_data_protected.routes
    least_frequent_routes = tracker_route.least_frequent
    least_frequent_routes_count = least_frequent_routes.size

    assert_equal(4, least_frequent_routes_count)
    assert_includes(least_frequent_routes, '/path?name=Angus')
    assert_includes(least_frequent_routes, '/path?')
    assert_includes(least_frequent_routes, '/path?color=red')
    assert_includes(least_frequent_routes, '/path?hero=SuperWoman')
    refute_includes(least_frequent_routes, '/path?metal=copper')
    refute_includes(least_frequent_routes, '/path?animal=elephant')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_routes_most_frequent_returns_expected_routes
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/path?name=Angus')
    mock_request.get('/path?')
    mock_request.get('/path?color=red')
    mock_request.get('/path?hero=SuperWoman')
    7.times do |_|
        mock_request.get('/path?metal=copper')
        mock_request.get('/path?animal=elephant')
    end

    tracker_route = middleware_wrapper.usage_data_protected.routes
    most_frequent_routes = tracker_route.most_frequent
    most_frequent_routes_count = most_frequent_routes.size

    assert_equal(2, most_frequent_routes_count)
    refute_includes(most_frequent_routes, '/path?name=Angus')
    refute_includes(most_frequent_routes, '/path?')
    refute_includes(most_frequent_routes, '/path?color=red')
    refute_includes(most_frequent_routes, '/path?hero=SuperWoman')
    assert_includes(most_frequent_routes, '/path?metal=copper')
    assert_includes(most_frequent_routes, '/path?animal=elephant')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_routes_has_longest_returns_expected_boolean
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    # before first request
    tracker_route = middleware_wrapper.usage_data_protected.routes
    has_longest_before_initial_request = tracker_route.has_longest?

    # after first request
    mock_request.get('/path?dog=woof')
    tracker_route = middleware_wrapper.usage_data_protected.routes
    has_longest_after_initial_request = tracker_route.has_longest?

    assert_equal(false, has_longest_before_initial_request)
    assert_equal(true, has_longest_after_initial_request)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_routes_longest_returns_expected_routes
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/path?a=65')
    mock_request.get('/path?item=Keyboard')
    mock_request.get('/path?name=John')
    mock_request.get('/path?coupon_code=JackTheRabbit')
    mock_request.get('/path?')

    tracker_route = middleware_wrapper.usage_data_protected.routes
    longest = tracker_route.longest
    
    assert_equal('/path?coupon_code=JackTheRabbit', longest)
  end
end
