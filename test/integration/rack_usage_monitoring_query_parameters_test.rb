require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageMonitoringQueryParametersTest < Minitest::Test
  def test_that_RackUsageMonitoring_UsageDataProtected_parameters_returns_instance_of_TrackerQueryParameter
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper

    tracker_query_parameter = middleware_wrapper.usage_data_protected.parameters

    assert_instance_of(RackUsageTracking::TrackerQueryParameter, tracker_query_parameter)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_parameters_least_frequent_returns_expected_parameters
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    1.times { |_| mock_request.get('/path?name=John&age=25') }
    3.times { |_| mock_request.get('/path?name=Bob&age=99') }
    5.times { |_| mock_request.get('/path?name=Frank&age=65') }
    1.times { |_| mock_request.get('/path?name=Shia&age=34') }

    tracker_query_parameter = middleware_wrapper.usage_data_protected.parameters
    least_frequent_parameters = tracker_query_parameter.least_frequent
    least_frequent_parameters_count = least_frequent_parameters.size

    assert_equal(4, least_frequent_parameters_count)
    assert_includes(least_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('name=John'))
    assert_includes(least_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('age=25'))
    assert_includes(least_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('name=Shia'))
    assert_includes(least_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('age=34'))

    refute_includes(least_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('name=Bob'))
    refute_includes(least_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('age=99'))
    refute_includes(least_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('name=Frank'))
    refute_includes(least_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('age=65'))
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_parameters_most_frequent_returns_expected_parameters
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    1.times { |_| mock_request.get('/path?name=John&age=25') }
    5.times { |_| mock_request.get('/path?name=Bob&age=99') }
    5.times { |_| mock_request.get('/path?name=Frank&age=65') }
    1.times { |_| mock_request.get('/path?name=Shia&age=34') }

    tracker_query_parameter = middleware_wrapper.usage_data_protected.parameters
    most_frequent_parameters = tracker_query_parameter.most_frequent
    most_frequent_parameters_count = most_frequent_parameters.size

    assert_equal(4, most_frequent_parameters_count)
    refute_includes(most_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('name=John'))
    refute_includes(most_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('age=25'))
    refute_includes(most_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('name=Shia'))
    refute_includes(most_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('age=34'))

    assert_includes(most_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('name=Bob'))
    assert_includes(most_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('age=99'))
    assert_includes(most_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('name=Frank'))
    assert_includes(most_frequent_parameters, RackUsageTrackingHelpers::QueryParameter.new('age=65'))
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_parameters_all_returns_expected_parameters
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    1.times { |_| mock_request.get('/path?name=John&age=25') }
    2.times { |_| mock_request.get('/path?name=Bob&age=99') }
    3.times { |_| mock_request.get('/path?name=Frank&age=65') }
    4.times { |_| mock_request.get('/path?name=Shia&age=34') }

    tracker_query_parameter = middleware_wrapper.usage_data_protected.parameters
    all_parameters = tracker_query_parameter.all
    all_parameters_count = all_parameters.size

    assert_equal(8, all_parameters_count)
    assert_includes(all_parameters, RackUsageTrackingHelpers::QueryParameter.new('name=John'))
    assert_includes(all_parameters, RackUsageTrackingHelpers::QueryParameter.new('age=25'))
    assert_includes(all_parameters, RackUsageTrackingHelpers::QueryParameter.new('name=Shia'))
    assert_includes(all_parameters, RackUsageTrackingHelpers::QueryParameter.new('age=34'))

    assert_includes(all_parameters, RackUsageTrackingHelpers::QueryParameter.new('name=Bob'))
    assert_includes(all_parameters, RackUsageTrackingHelpers::QueryParameter.new('age=99'))
    assert_includes(all_parameters, RackUsageTrackingHelpers::QueryParameter.new('name=Frank'))
    assert_includes(all_parameters, RackUsageTrackingHelpers::QueryParameter.new('age=65'))
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_parameters_has_longest_returns_expected_boolean
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    # before first request
    tracker_query_parameter = middleware_wrapper.usage_data_protected.parameters
    has_longest_before_initial_request = tracker_query_parameter.has_longest?

    # after first request
    mock_request.get('/path?dog=woof')
    tracker_query_parameter = middleware_wrapper.usage_data_protected.parameters
    has_longest_after_initial_request = tracker_query_parameter.has_longest?

    assert_equal(false, has_longest_before_initial_request)
    assert_equal(true, has_longest_after_initial_request)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_parameters_longest_returns_expected_parameters
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/path?key=AAA')
    mock_request.get('/path?key=BBBBBBBB')
    mock_request.get('/path?key=CCCCC')
    mock_request.get('/path?key=DDDDDDDDDDDD')
    mock_request.get('/path?key=')

    tracker_query_parameter = middleware_wrapper.usage_data_protected.parameters
    longest = tracker_query_parameter.longest
    
    assert_equal(RackUsageTrackingHelpers::QueryParameter.new('key=DDDDDDDDDDDD'), longest)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_parameters_average_per_request_returns_expected_average
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/path?')                # 0 parameters - 1 request
    mock_request.get('/path?1=1&2=2&3=3')     # 3 parameters - 1 request
    mock_request.get('/path?1=1&2=2&3=3&4=4') # 4 parameters - 1 request
    mock_request.get('/path?1=1')             # 1 parameter  - 1 request
    mock_request.get('/path?')                # 0 parameters - 1 request

    total_requests = 5
    total_parameters = 0.0 + 3.0 + 4.0 + 1.0 + 0.0
    expected_average_parameters_per_request = (total_parameters / total_requests.to_f)

    tracker_query_parameter = middleware_wrapper.usage_data_protected.parameters
    actual_average_parameters_per_request = tracker_query_parameter.average_per_request

    assert_equal(expected_average_parameters_per_request, actual_average_parameters_per_request)
  end
end