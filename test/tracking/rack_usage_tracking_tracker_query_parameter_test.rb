require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageTrackingTrackerQueryParameterTest < Minitest::Test
  def test_that_RackUsageTracking_TrackerQueryParameter_accessible_when_middleware_required
    tracker_query_parameter_accessible = defined?(RackUsageTracking::TrackerQueryParameter)

    assert(tracker_query_parameter_accessible)
  end
  
  def test_that_RackUsageTracking_TrackerQueryParameter_is_subclass_of_Tracker
    is_subclass_of_tracker = (RackUsageTracking::TrackerQueryParameter < RackUsageTracking::Tracker)

    assert_equal(true, is_subclass_of_tracker)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_requirements_met_takes_single_hash_as_argument_and_returns_false
    some_hash = Hash.new
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    requirements_met = tracker_query_parmeter.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_requirements_met_does_not_mutate_argument_hash
    some_hash = {'Iron' => 'Man', 'Spider' => 'Boy'}
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_query_parmeter.requirements_met?(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_requirements_met_returns_true_when_argument_hash_contains_expected_data
    expected_data_hash = { 'QUERY_STRING' => 'query' }
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    requirements_met = tracker_query_parmeter.requirements_met?(expected_data_hash)

    assert_equal(true, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_requirements_met_returns_false_when_argument_hash_does_not_contain_expected_data
    some_hash = Hash.new
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    requirements_met = tracker_query_parmeter.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_responds_to_track_data
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    responds_to_track_data = tracker_query_parmeter.respond_to?(:track_data)

    assert_equal(true, responds_to_track_data)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_track_data_does_not_mutate_argument_hash
    expected_data_hash = {'QUERY_STRING' => 'query'}
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    
    tracker_query_parmeter.track_data(expected_data_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_responds_to_least_frequent
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    responds_to_least_frequent = tracker_query_parmeter.respond_to?(:least_frequent)

    assert_equal(true, responds_to_least_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_least_frequent_returns_array
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    least_frequent = tracker_query_parmeter.least_frequent

    assert_instance_of(Array, least_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_least_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    least_frequent = tracker_query_parmeter.least_frequent

    assert_equal([], least_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_least_frequent_returns_array_with_expected_least_frequent_query_parameter_instances
    request_data_hashes = [
      {'QUERY_STRING' => '?size=medium'},
      {'QUERY_STRING' => '?size=XXL'},
      {'QUERY_STRING' => '?size=medium'}
    ]
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_parmeter.track_data(request_data_hash)
    end

    least_frequent = tracker_query_parmeter.least_frequent

    assert_equal(1, least_frequent.size)
    assert_includes(least_frequent, RackUsageTrackingHelpers::QueryParameter.new('size=XXL'))
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_least_frequent_returns_array_with_all_least_frequent_query_parameter_instances_with_identical_frequency
    request_data_hashes = [
      {'QUERY_STRING' => '?color=pink'},
      {'QUERY_STRING' => '?color=blue'},
      {'QUERY_STRING' => '?color=magenta'},
      {'QUERY_STRING' => '?color=pink'}
    ]
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_parmeter.track_data(request_data_hash)
    end

    least_frequent = tracker_query_parmeter.least_frequent

    assert_equal(2, least_frequent.size)
    assert_includes(least_frequent, RackUsageTrackingHelpers::QueryParameter.new('color=blue'))
    assert_includes(least_frequent, RackUsageTrackingHelpers::QueryParameter.new('color=magenta'))
    refute_includes(least_frequent, RackUsageTrackingHelpers::QueryParameter.new('color=pink'))
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_responds_to_most_frequent
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    responds_to_most_frequent = tracker_query_parmeter.respond_to?(:most_frequent)

    assert_equal(true, responds_to_most_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_most_frequent_returns_array
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    most_frequent = tracker_query_parmeter.most_frequent

    assert_instance_of(Array, most_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_most_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    most_frequent = tracker_query_parmeter.most_frequent

    assert_equal([], most_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_most_frequent_returns_array_with_expected_most_frequent_query_parameter_instances
    skip
    request_data_hashes = [
      {'QUERY_STRING' => 'seats=5&model'},
      {'QUERY_STRING' => 'HTTP/2.0'},
      {'QUERY_STRING' => 'HTTP/0.9'},
      {'QUERY_STRING' => 'HTTP/2.0'}
    ]
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_parmeter.track_data(request_data_hash)
    end

    most_frequent = tracker_query_parmeter.most_frequent

    assert_equal(1, most_frequent.size)
    assert_includes(most_frequent, RackUsageTrackingHelpers::QueryParameter.new('HTTP/2.0'))
  end

=begin
  def test_that_RackUsageTracking_TrackerQueryParameter_most_frequent_returns_array_with_all_most_frequent_query_parameter_instances_with_identical_frequency
    request_data_hashes = [
      {'QUERY_STRING' => 'HTTP/0.9'},
      {'QUERY_STRING' => 'HTTP/0.9'},
      {'QUERY_STRING' => 'HTTP/1.1'},
      {'QUERY_STRING' => 'HTTP/1.1'},
      {'QUERY_STRING' => 'HTTP/2.0'}
    ]
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_parmeter.track_data(request_data_hash)
    end

    most_frequent = tracker_query_parmeter.most_frequent

    assert_equal(2, most_frequent.size)
    assert_includes(most_frequent, RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9'))
    assert_includes(most_frequent, RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.1'))
    refute_includes(most_frequent, RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0'))
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_responds_to_all
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    responds_to_all = tracker_query_parmeter.respond_to?(:all)

    assert_equal(true, responds_to_all)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_all_returns_array
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    all = tracker_query_parmeter.all

    assert_instance_of(Array, all)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_all_returns_empty_array_when_no_data_tracked_yet
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    all = tracker_query_parmeter.all

    assert_equal([], all)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_all_returns_array_with_all_tracked_query_parameter_instances
    request_data_hashes = [
      {'QUERY_STRING' => 'HTTP/2.0'},
      {'QUERY_STRING' => 'HTTP/1.0'},
      {'QUERY_STRING' => 'HTTP/1.0'},
      {'QUERY_STRING' => 'HTTP/0.9'},
      {'QUERY_STRING' => 'HTTP/0.9'},
      {'QUERY_STRING' => 'HTTP/0.9'}
    ]
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_parmeter.track_data(request_data_hash)
    end

    all = tracker_query_parmeter.all

    assert_equal(3, all.size)
    assert_includes(all, RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0'))
    assert_includes(all, RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.0'))
    assert_includes(all, RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9'))
  end
=end
end