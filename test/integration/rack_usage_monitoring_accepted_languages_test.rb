require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageMonitoringHttpMethodsTest < Minitest::Test
  def test_that_RackUsageMonitoring_UsageDataProtected_accepted_languages_returns_instance_of_TrackerAcceptedLanguage
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper

    tracker_accepted_language = middleware_wrapper.usage_data_protected.accepted_languages

    assert_instance_of(RackUsageTracking::TrackerAcceptedLanguage, tracker_accepted_language)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_accepted_languages_least_frequent_returns_expected_accepted_language_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    skip
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    3.times { |_| mock_request.get('/', 'HTTP_ACCEPT' => 'fr-CH') }
    3.times { |_| mock_request.get('/', 'HTTP_ACCEPT' => 'fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5') }
    3.times { |_| mock_request.get('/', 'HTTP_ACCEPT' => 'fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5') }
    3.times { |_| mock_request.get('/', 'HTTP_ACCEPT' => 'fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5') }

    tracker_accepted_language = middleware_wrapper.usage_data_protected.accepted_languages
    least_frequent_methods = tracker_accepted_language.least_frequent
    least_frequent_methods_count = least_frequent_methods.size

    assert_equal(2, least_frequent_methods_count)
    assert_includes(least_frequent_methods, 'GET')
    assert_includes(least_frequent_methods, 'OPTIONS')
    refute_includes(least_frequent_methods, 'PUT')
    refute_includes(least_frequent_methods, 'POST')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_accepted_languages_most_frequent_returns_expected_accepted_language_strings
skip
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    5.times { |_| mock_request.get('/') }
    11.times { |_| mock_request.put('/') }
    11.times { |_| mock_request.post('/') }
    9.times { |_| mock_request.options('/') }

    tracker_accepted_language = middleware_wrapper.usage_data_protected.accepted_languages
    most_frequent_methods = tracker_accepted_language.most_frequent
    most_frequent_methods_count = most_frequent_methods.size

    assert_equal(2, most_frequent_methods_count)
    assert_includes(most_frequent_methods, 'PUT')
    assert_includes(most_frequent_methods, 'POST')
    refute_includes(most_frequent_methods, 'GET')
    refute_includes(most_frequent_methods, 'OPTIONS')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_accepted_languages_all_returns_expected_accepted_language_strings
skip
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    5.times { |_| mock_request.get('/') }
    6.times { |_| mock_request.put('/') }
    17.times { |_| mock_request.post('/') }
    9.times { |_| mock_request.options('/') }

    tracker_accepted_language = middleware_wrapper.usage_data_protected.accepted_languages
    all_methods = tracker_accepted_language.all
    all_methods_count = all_methods.size

    assert_equal(4, all_methods_count)
    assert_includes(all_methods, 'GET')
    assert_includes(all_methods, 'PUT')
    assert_includes(all_methods, 'POST')
    assert_includes(all_methods, 'OPTIONS')
  end
end
