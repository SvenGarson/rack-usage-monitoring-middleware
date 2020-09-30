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
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/', {'HTTP_ACCEPT_LANGUAGE' => 'fr;q=0.5, de;q=0.7, en;q=1.0'})
    mock_request.get('/', {'HTTP_ACCEPT_LANGUAGE' => '*;q=0.1'})
    2.times do |_|
        mock_request.get('/', {'HTTP_ACCEPT_LANGUAGE' => 'es, no, ru'})
    end

    tracker_accepted_language = middleware_wrapper.usage_data_protected.accepted_languages
    least_frequent_languages = tracker_accepted_language.least_frequent
    least_frequent_languages_count = least_frequent_languages.size

    assert_equal(4, least_frequent_languages_count)
    assert_includes(least_frequent_languages, 'fr')
    assert_includes(least_frequent_languages, 'de')
    assert_includes(least_frequent_languages, 'en')
    assert_includes(least_frequent_languages, '*')
    refute_includes(least_frequent_languages, 'es')
    refute_includes(least_frequent_languages, 'no')
    refute_includes(least_frequent_languages, 'ru')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_accepted_languages_most_frequent_returns_expected_accepted_language_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/', {'HTTP_ACCEPT_LANGUAGE' => 'fr;q=0.5, de;q=0.7, en;q=1.0'})
    mock_request.get('/', {'HTTP_ACCEPT_LANGUAGE' => '*;q=0.1'})
    2.times do |_|
        mock_request.get('/', {'HTTP_ACCEPT_LANGUAGE' => 'es, no, ru'})
    end

    tracker_accepted_language = middleware_wrapper.usage_data_protected.accepted_languages
    most_frequent_languages = tracker_accepted_language.most_frequent
    most_frequent_languages_count = most_frequent_languages.size

    assert_equal(3, most_frequent_languages_count)
    assert_includes(most_frequent_languages, 'es')
    assert_includes(most_frequent_languages, 'no')
    assert_includes(most_frequent_languages, 'ru')
    refute_includes(most_frequent_languages, 'fr')
    refute_includes(most_frequent_languages, 'de')
    refute_includes(most_frequent_languages, 'en')
    refute_includes(most_frequent_languages, '*')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_accepted_languages_all_returns_expected_accepted_language_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/', {'HTTP_ACCEPT_LANGUAGE' => 'fr;q=0.5, de;q=0.7, en;q=1.0'})
    mock_request.get('/', {'HTTP_ACCEPT_LANGUAGE' => '*;q=0.1'})
    2.times do |_|
        mock_request.get('/', {'HTTP_ACCEPT_LANGUAGE' => 'es, no, ru'})
    end

    tracker_accepted_language = middleware_wrapper.usage_data_protected.accepted_languages
    all_languages = tracker_accepted_language.all
    all_languages_count = all_languages.size

    assert_equal(7, all_languages_count)
    assert_includes(all_languages, 'fr')
    assert_includes(all_languages, 'de')
    assert_includes(all_languages, 'en')
    assert_includes(all_languages, '*')
    assert_includes(all_languages, 'es')
    assert_includes(all_languages, 'no')
    assert_includes(all_languages, 'ru')
  end
end
