require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageMonitoringPathsTest < Minitest::Test
  def test_that_RackUsageMonitoring_UsageDataProtected_paths_returns_instance_of_TrackerPath
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper

    tracker_path = middleware_wrapper.usage_data_protected.paths

    assert_instance_of(RackUsageTracking::TrackerPath, tracker_path)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_paths_least_frequent_returns_expected_path_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/fruit')
    mock_request.get('/books')
    mock_request.get('/fish')
    6.times do |_|
        mock_request.get('/cans')
        mock_request.get('/metals')
    end

    tracker_path = middleware_wrapper.usage_data_protected.paths
    least_frequent_paths = tracker_path.least_frequent
    least_frequent_paths_count = least_frequent_paths.size

    assert_equal(3, least_frequent_paths_count)
    assert_includes(least_frequent_paths, '/fruit')
    assert_includes(least_frequent_paths, '/books')
    assert_includes(least_frequent_paths, '/fish')
    refute_includes(least_frequent_paths, '/cans')
    refute_includes(least_frequent_paths, '/metals')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_paths_most_frequent_returns_expected_path_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/fruit')
    mock_request.get('/books')
    mock_request.get('/fish')
    6.times do |_|
        mock_request.get('/cans')
        mock_request.get('/metals')
    end

    tracker_path = middleware_wrapper.usage_data_protected.paths
    most_frequent_paths = tracker_path.most_frequent
    most_frequent_paths_count = most_frequent_paths.size

    assert_equal(2, most_frequent_paths_count)
    refute_includes(most_frequent_paths, '/fruit')
    refute_includes(most_frequent_paths, '/books')
    refute_includes(most_frequent_paths, '/fish')
    assert_includes(most_frequent_paths, '/cans')
    assert_includes(most_frequent_paths, '/metals')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_paths_has_longest_returns_expected_boolean
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    # before first request
    tracker_path = middleware_wrapper.usage_data_protected.paths
    has_longest_before_initial_request = tracker_path.has_longest?

    # after first request
    mock_request.get('/mugs/custom_logo')
    tracker_path = middleware_wrapper.usage_data_protected.paths
    has_longest_after_initial_request = tracker_path.has_longest?

    assert_equal(false, has_longest_before_initial_request)
    assert_equal(true, has_longest_after_initial_request)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_paths_longest_returns_expected_path_string
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/')
    mock_request.get('/clothing')
    mock_request.get('/books')
    mock_request.get('/this/is/the/longest')
    mock_request.get('/')

    tracker_path = middleware_wrapper.usage_data_protected.paths
    longest = tracker_path.longest
    
    assert_equal('/this/is/the/longest', longest)
  end
end
