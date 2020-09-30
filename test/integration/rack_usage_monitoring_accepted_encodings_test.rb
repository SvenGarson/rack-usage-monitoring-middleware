require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageMonitoringAcceptedEncodingsTest < Minitest::Test
  def test_that_RackUsageMonitoring_UsageDataProtected_accepted_encodings_returns_instance_of_TrackerAcceptedEncoding
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper

    tracker_accepted_encoding = middleware_wrapper.usage_data_protected.accepted_encodings

    assert_instance_of(RackUsageTracking::TrackerAcceptedEncoding, tracker_accepted_encoding)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_accepted_encodings_least_frequent_returns_expected_accepted_encoding_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/', {'HTTP_ACCEPT_ENCODING' => 'compress;q=0.5, deflate;q=0.7, gzip;q=1.0'})
    mock_request.get('/', {'HTTP_ACCEPT_ENCODING' => '*;q=0.1'})
    2.times do |_|
        mock_request.get('/', {'HTTP_ACCEPT_ENCODING' => 'br, identity'})
    end

    tracker_accepted_encoding = middleware_wrapper.usage_data_protected.accepted_encodings
    least_frequent_encodings = tracker_accepted_encoding.least_frequent
    least_frequent_encodings_count = least_frequent_encodings.size

    assert_equal(4, least_frequent_encodings_count)
    assert_includes(least_frequent_encodings, 'compress')
    assert_includes(least_frequent_encodings, 'deflate')
    assert_includes(least_frequent_encodings, 'gzip')
    assert_includes(least_frequent_encodings, '*')
    refute_includes(least_frequent_encodings, 'br')
    refute_includes(least_frequent_encodings, 'identity')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_accepted_encodings_most_frequent_returns_expected_accepted_encoding_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/', {'HTTP_ACCEPT_ENCODING' => 'compress;q=0.5, deflate;q=0.7, gzip;q=1.0'})
    mock_request.get('/', {'HTTP_ACCEPT_ENCODING' => '*;q=0.1'})
    2.times do |_|
        mock_request.get('/', {'HTTP_ACCEPT_ENCODING' => 'br, identity'})
    end

    tracker_accepted_encoding = middleware_wrapper.usage_data_protected.accepted_encodings
    most_frequent_encodings = tracker_accepted_encoding.most_frequent
    most_frequent_encodings_count = most_frequent_encodings.size

    assert_equal(2, most_frequent_encodings_count)
    refute_includes(most_frequent_encodings, 'compress')
    refute_includes(most_frequent_encodings, 'deflate')
    refute_includes(most_frequent_encodings, 'gzip')
    refute_includes(most_frequent_encodings, '*')
    assert_includes(most_frequent_encodings, 'br')
    assert_includes(most_frequent_encodings, 'identity')
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_accepted_encodings_all_returns_expected_accepted_encoding_strings
    middleware_wrapper = Helpers.middleware_usage_data_protected_access_wrapper
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    mock_request.get('/', {'HTTP_ACCEPT_ENCODING' => 'compress;q=0.5, deflate;q=0.7, gzip;q=1.0'})
    mock_request.get('/', {'HTTP_ACCEPT_ENCODING' => '*;q=0.1'})
    2.times do |_|
        mock_request.get('/', {'HTTP_ACCEPT_ENCODING' => 'br, identity'})
    end

    tracker_accepted_encoding = middleware_wrapper.usage_data_protected.accepted_encodings
    all_encodings = tracker_accepted_encoding.all
    all_encodings_count = all_encodings.size

    assert_equal(6, all_encodings_count)
    assert_includes(all_encodings, 'compress')
    assert_includes(all_encodings, 'deflate')
    assert_includes(all_encodings, 'gzip')
    assert_includes(all_encodings, '*')
    assert_includes(all_encodings, 'br')
    assert_includes(all_encodings, 'identity')
  end
end
