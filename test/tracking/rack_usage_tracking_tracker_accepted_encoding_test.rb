require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageTrackingTrackerAcceptedEncodingTest < Minitest::Test
  def test_that_RackUsageTracking_TrackerAcceptedEncoding_accessible_when_middleware_required
    tracker_accepted_encoding_accessible = defined?(RackUsageTracking::TrackerAcceptedEncoding)

    assert(tracker_accepted_encoding_accessible)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_is_subclass_of_Tracker
    is_subclass_of_tracker = (RackUsageTracking::TrackerAcceptedEncoding < RackUsageTracking::Tracker)

    assert_equal(true, is_subclass_of_tracker)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_requirements_met_takes_single_hash_as_argument_and_returns_false
    some_hash = Hash.new
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    requirements_met = tracker_accepted_encoding.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_requirements_met_does_not_mutate_argument_hash
    some_hash = {'Iron' => 'Man', 'Spider' => 'Boy'}
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_accepted_encoding.requirements_met?(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_requirements_met_returns_true_when_argument_hash_contains_expected_data
    expected_data_hash = { 'HTTP_ACCEPT_ENCODING' => 'encoding' }
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    requirements_met = tracker_accepted_encoding.requirements_met?(expected_data_hash)

    assert_equal(true, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_requirements_met_returns_false_when_argument_hash_does_not_contain_expected_data
    some_hash = Hash.new
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    requirements_met = tracker_accepted_encoding.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_responds_to_track_data
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    responds_to_track_data = tracker_accepted_encoding.respond_to?(:track_data)

    assert_equal(true, responds_to_track_data)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_track_data_does_not_mutate_argument_hash
    expected_data_hash = {'HTTP_ACCEPT_ENCODING' => 'deflate'}
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    
    tracker_accepted_encoding.track_data(expected_data_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_responds_to_least_frequent
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    responds_to_least_frequent = tracker_accepted_encoding.respond_to?(:least_frequent)

    assert_equal(true, responds_to_least_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_least_frequent_returns_array
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    least_frequent = tracker_accepted_encoding.least_frequent

    assert_instance_of(Array, least_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_least_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    least_frequent = tracker_accepted_encoding.least_frequent

    assert_equal([], least_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_least_frequent_returns_array_with_expected_least_frequent_objects
    request_data_hashes = [
      {'HTTP_ACCEPT_ENCODING' => 'deflate;q=0.6'},
      {'HTTP_ACCEPT_ENCODING' => 'gzip;q=1.0'},
      {'HTTP_ACCEPT_ENCODING' => 'deflate;q=0.6'},
    ]
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_encoding.track_data(request_data_hash)
    end

    least_frequent = tracker_accepted_encoding.least_frequent

    assert_equal(%w(gzip), least_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_least_frequent_returns_array_with_all_least_frequent_objects_with_identical_frequency
    request_data_hashes = [
      {'HTTP_ACCEPT_ENCODING' => 'gzip;q=1.0'},
      {'HTTP_ACCEPT_ENCODING' => 'deflate;q=0.6'},
      {'HTTP_ACCEPT_ENCODING' => 'deflate;q=0.6'},
      {'HTTP_ACCEPT_ENCODING' => '*;q=0.2'}
    ]
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_encoding.track_data(request_data_hash)
    end

    least_frequent = tracker_accepted_encoding.least_frequent

    assert_equal(2, least_frequent.size)
    assert_includes(least_frequent, 'gzip')
    assert_includes(least_frequent, '*')
    refute_includes(least_frequent, 'deflate')
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_least_frequent_returns_array_with_dupped_least_frequent_objects
    accepted_encodings_string = 'gzip;q=1.0'

    request_data_hashes = [
      { 'HTTP_ACCEPT_ENCODING' => accepted_encodings_string },
      { 'HTTP_ACCEPT_ENCODING' => accepted_encodings_string },
      { 'HTTP_ACCEPT_ENCODING' => accepted_encodings_string }
    ]
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_encoding.track_data(request_data_hash)
    end

    least_frequent = tracker_accepted_encoding.least_frequent

    least_frequent.each do |least_frequent_object|    
      refute_same(least_frequent_object, accepted_encodings_string)
    end
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_responds_to_most_frequent
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    responds_to_most_frequent = tracker_accepted_encoding.respond_to?(:most_frequent)

    assert_equal(true, responds_to_most_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_most_frequent_returns_array
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    most_frequent = tracker_accepted_encoding.most_frequent

    assert_instance_of(Array, most_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_most_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    most_frequent = tracker_accepted_encoding.most_frequent

    assert_equal([], most_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_most_frequent_returns_array_with_expected_most_frequent_objects
    request_data_hashes = [
      {'HTTP_ACCEPT_ENCODING' => 'gzip;q=1.0'},
      {'HTTP_ACCEPT_ENCODING' => 'deflate;q=0.6'},
      {'HTTP_ACCEPT_ENCODING' => '*;q=0.2'},
      {'HTTP_ACCEPT_ENCODING' => 'deflate;q=0.6'}
    ]
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_encoding.track_data(request_data_hash)
    end

    most_frequent = tracker_accepted_encoding.most_frequent

    assert_equal(%w(deflate), most_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_most_frequent_returns_array_with_all_most_frequent_objects_with_identical_frequency
    request_data_hashes = [
      {'HTTP_ACCEPT_ENCODING' => 'gzip;q=1.0'},
      {'HTTP_ACCEPT_ENCODING' => 'gzip;q=1.0'},
      {'HTTP_ACCEPT_ENCODING' => 'deflate;q=0.6'},
      {'HTTP_ACCEPT_ENCODING' => 'deflate;q=0.6'},
      {'HTTP_ACCEPT_ENCODING' => '*;q=0.2'}
    ]
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_encoding.track_data(request_data_hash)
    end

    most_frequent = tracker_accepted_encoding.most_frequent

    assert_equal(2, most_frequent.size)
    assert_includes(most_frequent, 'gzip')
    assert_includes(most_frequent, 'deflate')
    refute_includes(most_frequent, '*')
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_most_frequent_returns_array_with_dupped_most_frequent_objects
    accepted_encodings_string = 'gzip;q=1.0'

    request_data_hashes = [
      {'HTTP_ACCEPT_ENCODING' => accepted_encodings_string},
      {'HTTP_ACCEPT_ENCODING' => accepted_encodings_string},
      {'HTTP_ACCEPT_ENCODING' => accepted_encodings_string}
    ]
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_encoding.track_data(request_data_hash)
    end

    most_frequent = tracker_accepted_encoding.most_frequent

    most_frequent.each do |most_frequent_object|    
      refute_same(most_frequent_object, accepted_encodings_string)
    end
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_responds_to_all
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    responds_to_all = tracker_accepted_encoding.respond_to?(:all)

    assert_equal(true, responds_to_all)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_all_returns_array
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    all = tracker_accepted_encoding.all

    assert_instance_of(Array, all)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_all_returns_empty_array_when_no_data_tracked_yet
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    all = tracker_accepted_encoding.all

    assert_equal([], all)
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_all_returns_array_with_all_tracked_objects
    request_data_hashes = [
      {'HTTP_ACCEPT_ENCODING' => 'gzip;q=1.0'},
      {'HTTP_ACCEPT_ENCODING' => 'deflate;q=0.6'},
      {'HTTP_ACCEPT_ENCODING' => 'deflate;q=0.6'},
      {'HTTP_ACCEPT_ENCODING' => '*;q=0.2'},
      {'HTTP_ACCEPT_ENCODING' => '*;q=0.2'},
      {'HTTP_ACCEPT_ENCODING' => '*;q=0.2'}
    ]
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_encoding.track_data(request_data_hash)
    end

    all = tracker_accepted_encoding.all

    assert_equal(3, all.size)
    assert_includes(all, 'gzip')
    assert_includes(all, 'deflate')
    assert_includes(all, '*')
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_all_returns_array_with_tracked_objects_dupped
    accepted_encodings_string = 'deflate;q=0.6'

    request_data_hashes = [
      {'HTTP_ACCEPT_ENCODING' => accepted_encodings_string},
      {'HTTP_ACCEPT_ENCODING' => accepted_encodings_string},
      {'HTTP_ACCEPT_ENCODING' => accepted_encodings_string}
    ]
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_encoding.track_data(request_data_hash)
    end

    all = tracker_accepted_encoding.all

    all.each do |all_object|    
      refute_same(all_object, accepted_encodings_string)
    end
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_parses_encoding_only_string_correctly
    accepted_encodings_request_hash = {'HTTP_ACCEPT_ENCODING' => 'deflate'}
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    tracker_accepted_encoding.track_data(accepted_encodings_request_hash)
    all = tracker_accepted_encoding.all

    assert_equal(1, all.size)
    assert_includes(all, 'deflate')
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_parses_encoding_with_weight_string_correctly
    accepted_encodings_request_hash = {'HTTP_ACCEPT_ENCODING' => 'deflate;q=0.6'}
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    tracker_accepted_encoding.track_data(accepted_encodings_request_hash)
    all = tracker_accepted_encoding.all

    assert_equal(1, all.size)
    assert_includes(all, 'deflate')
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_parses_wildcard_only_string_correctly
    accepted_encodings_request_hash = {'HTTP_ACCEPT_ENCODING' => '*'}
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    tracker_accepted_encoding.track_data(accepted_encodings_request_hash)
    all = tracker_accepted_encoding.all

    assert_equal(1, all.size)
    assert_includes(all, '*')
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_parses_wildcard_with_weight_string_correctly
    accepted_encodings_request_hash = {'HTTP_ACCEPT_ENCODING' => '*;q=0.5'}
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    tracker_accepted_encoding.track_data(accepted_encodings_request_hash)
    all = tracker_accepted_encoding.all

    assert_equal(1, all.size)
    assert_includes(all, '*')
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_parses_no_encoding_with_weight_string_correctly
    accepted_encodings_request_hash = {'HTTP_ACCEPT_ENCODING' => ';q=0.9'}
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    tracker_accepted_encoding.track_data(accepted_encodings_request_hash)
    all = tracker_accepted_encoding.all

    assert_equal(1, all.size)
    assert_includes(all, '')
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_parses_empty_string_correctly
    accepted_encodings_request_hash = {'HTTP_ACCEPT_ENCODING' => ''}
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    tracker_accepted_encoding.track_data(accepted_encodings_request_hash)
    all = tracker_accepted_encoding.all

    assert_equal(1, all.size)
    assert_includes(all, '')
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_parses_multi_encoding_header_correctly
    accepted_encodings = ['gzip', 'deflate;q=0.5', '*', 'compress;q=0.1', ';q=0.3'].join(',')
    accepted_encodings_request_hash = { 'HTTP_ACCEPT_ENCODING' => accepted_encodings }
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    tracker_accepted_encoding.track_data(accepted_encodings_request_hash)
    all = tracker_accepted_encoding.all

    assert_equal(5, all.size)
    assert_includes(all, 'gzip')
    assert_includes(all, 'deflate')
    assert_includes(all, '*')
    assert_includes(all, 'compress')
    assert_includes(all, '')
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_parses_multi_encoding_header_with_leading_and_trailing_whitespace_around_encoding_correctly
    accepted_encodings = [
      '    gzip',
      'deflate  ;      q=0.5    ',
      '   *   ',
      '    compress  ;  q=0.1',
      '     ;q=0.3   '
    ].join(',')

    accepted_encodings_request_hash = { 'HTTP_ACCEPT_ENCODING' => accepted_encodings }
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    tracker_accepted_encoding.track_data(accepted_encodings_request_hash)
    all = tracker_accepted_encoding.all

    assert_equal(5, all.size)
    assert_includes(all, 'gzip')
    assert_includes(all, 'deflate')
    assert_includes(all, '*')
    assert_includes(all, 'compress')
    assert_includes(all, '')
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_parses_multi_encoding_header_with_encodings_separated_by_comma_correctly
    accepted_encodings = ['gzip;q=0.5', 'deflate;q=0.6', 'compress;q=0.7'].join(',')
    accepted_encodings_request_hash = { 'HTTP_ACCEPT_ENCODING' => accepted_encodings }
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    tracker_accepted_encoding.track_data(accepted_encodings_request_hash)
    all = tracker_accepted_encoding.all

    assert_equal(3, all.size)
    assert_includes(all, 'gzip')
    assert_includes(all, 'deflate')
    assert_includes(all, 'compress')
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_parses_multi_encoding_header_with_encodings_separated_by_comma_space_correctly
    accepted_encodings = ['gzip;q=0.5', 'deflate;q=0.6', 'compress;q=0.7'].join(', ')
    accepted_encodings_request_hash = { 'HTTP_ACCEPT_ENCODING' => accepted_encodings }
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    tracker_accepted_encoding.track_data(accepted_encodings_request_hash)
    all = tracker_accepted_encoding.all

    assert_equal(3, all.size)
    assert_includes(all, 'gzip')
    assert_includes(all, 'deflate')
    assert_includes(all, 'compress')
  end

  def test_that_RackUsageTracking_TrackerAcceptedEncoding_parses_multi_encoding_header_with_encodings_separated_by_comma_or_comma_space_correctly
    comma = ','
    comma_space = ', '
    accepted_encodings = 'gzip;q=0.5' + comma_space + 'deflate;q=0.6' + comma + '*;q=0.2' + comma_space + ';q=0.7'
    accepted_encodings_request_hash = { 'HTTP_ACCEPT_ENCODING' => accepted_encodings }
    tracker_accepted_encoding = RackUsageTracking::TrackerAcceptedEncoding.new

    tracker_accepted_encoding.track_data(accepted_encodings_request_hash)
    all = tracker_accepted_encoding.all

    assert_equal(4, all.size)
    assert_includes(all, 'gzip')
    assert_includes(all, 'deflate')
    assert_includes(all, '*')
    assert_includes(all, '')
  end
end