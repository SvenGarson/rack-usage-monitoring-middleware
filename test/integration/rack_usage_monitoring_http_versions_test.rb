require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageMonitoringHttpVersionsTest < Minitest::Test
  def test_that_RackUsageMonitoring_UsageDataProtected_http_versions_returns_instance_of_TrackerHttpVersion
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper

    tracker_http_version = middleware_wrapper.usage_data_protected.http_versions

    assert_instance_of(RackUsageTracking::TrackerHttpVersion, tracker_http_version)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_http_versions_least_frequent_returns_expected_http_versions
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    3.times  { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/1.1' }) }
    7.times  { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/2.0' }) }
    11.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/1.0' }) }
    3.times  { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/0.9' }) }

    tracker_http_version = middleware_wrapper.usage_data_protected.http_versions
    least_frequent_versions = tracker_http_version.least_frequent
    least_frequent_versions_count = least_frequent_versions.size

    assert_equal(2, least_frequent_versions_count)
    assert_includes(least_frequent_versions, RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.1'))
    assert_includes(least_frequent_versions, RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9'))
    refute_includes(least_frequent_versions, RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0'))
    refute_includes(least_frequent_versions, RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.0'))
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_http_versions_most_frequent_returns_expected_http_versions
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    5.times  { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/1.1' }) }
    11.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/2.0' }) }
    11.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/1.0' }) }
    9.times  { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/0.9' }) }

    tracker_http_version = middleware_wrapper.usage_data_protected.http_versions
    most_frequent_versions = tracker_http_version.most_frequent
    most_frequent_versions_count = most_frequent_versions.size

    assert_equal(2, most_frequent_versions_count)
    assert_includes(most_frequent_versions, RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0'))
    assert_includes(most_frequent_versions, RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.0'))
    refute_includes(most_frequent_versions, RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.1'))
    refute_includes(most_frequent_versions, RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9'))
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_http_versions_all_returns_expected_http_versions
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    2.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/0.9' }) }
    3.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/1.0' }) }
    4.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/1.1' }) }
    5.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/2.0' }) }

    tracker_http_version = middleware_wrapper.usage_data_protected.http_versions
    all_versions = tracker_http_version.all
    all_versions_count = all_versions.size

    assert_equal(4, all_versions_count)
    assert_includes(all_versions, RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9'))
    assert_includes(all_versions, RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.0'))
    assert_includes(all_versions, RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.1'))
    assert_includes(all_versions, RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0'))
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_http_versions_has_ranking_returns_expected_boolean
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    # before first request
    tracker_http_version = middleware_wrapper.usage_data_protected.http_versions
    has_ranking_before_initial_request = tracker_http_version.has_ranking?

    # after first request
    mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/1.0' })
    tracker_http_version = middleware_wrapper.usage_data_protected.http_versions
    has_ranking_after_initial_request = tracker_http_version.has_ranking?

    assert_equal(false, has_ranking_before_initial_request)
    assert_equal(true, has_ranking_after_initial_request)    
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_http_versions_lowest_returns_expected_lowest_ranking_http_version
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    5.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/1.0' }) }
    6.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/0.9' }) }
    7.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/2.0' }) }
    8.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/1.1' }) }

    tracker_http_version = middleware_wrapper.usage_data_protected.http_versions
    lowest_ranking = tracker_http_version.lowest

    assert_equal(RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9'), lowest_ranking)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_http_versions_highest_returns_expected_highest_ranking_http_version
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    5.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/1.0' }) }
    6.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/0.9' }) }
    7.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/2.0' }) }
    8.times { |_| mock_request.get('/', { 'HTTP_VERSION' => 'HTTP/1.1' }) }

    tracker_http_version = middleware_wrapper.usage_data_protected.http_versions
    highest_ranking = tracker_http_version.highest

    assert_equal(RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0'), highest_ranking)
  end
end
