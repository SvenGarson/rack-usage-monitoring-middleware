require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageMonitoringQueryStringsTest < Minitest::Test
  def test_that_RackUsageMonitoring_UsageDataProtected_query_strings_returns_instance_of_TrackerQueryString
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper

    tracker_query_string = middleware_wrapper.usage_data_protected.query_strings

    assert_instance_of(RackUsageTracking::TrackerQueryString, tracker_query_string)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_query_strings_least_frequent_returns_expected_query_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/path?name=Angus')
    mock_request.get('/path?')
    mock_request.get('/path?color=red')
    mock_request.get('/path?hero=SuperWoman')
    4.times do |_|
        mock_request.get('/path?metal=copper')
        mock_request.get('/path?animal=elephant')
    end

    tracker_query_string = middleware_wrapper.usage_data_protected.query_strings
    least_frequent_query_strings = tracker_query_string.least_frequent
    least_frequent_query_strings_count = least_frequent_query_strings.size

    assert_equal(4, least_frequent_query_strings_count)
    assert_includes(least_frequent_query_strings, 'name=Angus')
    assert_includes(least_frequent_query_strings, '')
    assert_includes(least_frequent_query_strings, 'color=red')
    assert_includes(least_frequent_query_strings, 'hero=SuperWoman')
    refute_includes(least_frequent_query_strings, 'metal=copper')
    refute_includes(least_frequent_query_strings, 'animal=elephant')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_query_strings_most_frequent_returns_expected_query_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/path?name=Angus')
    mock_request.get('/path?')
    mock_request.get('/path?color=red')
    mock_request.get('/path?hero=SuperWoman')
    4.times do |_|
        mock_request.get('/path?metal=copper')
        mock_request.get('/path?animal=elephant')
    end

    tracker_query_string = middleware_wrapper.usage_data_protected.query_strings
    most_frequent_query_strings = tracker_query_string.most_frequent
    most_frequent_query_strings_count = most_frequent_query_strings.size

    assert_equal(2, most_frequent_query_strings_count)
    refute_includes(most_frequent_query_strings, 'name=Angus')
    refute_includes(most_frequent_query_strings, '')
    refute_includes(most_frequent_query_strings, 'color=red')
    refute_includes(most_frequent_query_strings, 'hero=SuperWoman')
    assert_includes(most_frequent_query_strings, 'metal=copper')
    assert_includes(most_frequent_query_strings, 'animal=elephant')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_query_strings_has_longest_returns_expected_boolean
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    # before first request
    tracker_query_string = middleware_wrapper.usage_data_protected.query_strings
    has_longest_before_initial_request = tracker_query_string.has_longest?

    # after first request
    mock_request.get('/path?dog=woof')
    tracker_query_string = middleware_wrapper.usage_data_protected.query_strings
    has_longest_after_initial_request = tracker_query_string.has_longest?

    assert_equal(false, has_longest_before_initial_request)
    assert_equal(true, has_longest_after_initial_request)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_query_strings_longest_returns_expected_query_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/path?a=65')
    mock_request.get('/path?item=Keyboard')
    mock_request.get('/path?name=John')
    mock_request.get('/path?coupon_code=JackTheRabbit')
    mock_request.get('/path?')

    tracker_query_string = middleware_wrapper.usage_data_protected.query_strings
    longest = tracker_query_string.longest
    
    assert_equal('coupon_code=JackTheRabbit', longest)
  end
end
