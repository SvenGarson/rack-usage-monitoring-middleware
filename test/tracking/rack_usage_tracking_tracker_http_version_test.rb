require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageTrackingTrackerHttpVersionTest < Minitest::Test
  def test_that_RackUsageTracking_TrackerHttpVersion_accessible_when_middleware_required
    tracker_http_version_accessible = defined?(RackUsageTracking::TrackerHttpVersion)

    assert(tracker_http_version_accessible)
  end
  def test_that_RackUsageTracking_TrackerHttpVersion_is_subclass_of_Tracker
    is_subclass_of_tracker = (RackUsageTracking::TrackerHttpVersion < RackUsageTracking::Tracker)

    assert_equal(true, is_subclass_of_tracker)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_requirements_met_takes_single_hash_as_argument_and_returns_false
    some_hash = Hash.new
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    requirements_met = tracker_http_version.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_requirements_met_does_not_mutate_argument_hash
    some_hash = {'Iron' => 'Man', 'Spider' => 'Boy'}
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_http_version.requirements_met?(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_requirements_met_returns_true_when_argument_hash_contains_expected_data
    expected_data_hash = { 'HTTP_VERSION' => 'version' }
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    requirements_met = tracker_http_version.requirements_met?(expected_data_hash)

    assert_equal(true, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_requirements_met_returns_false_when_argument_hash_does_not_contain_expected_data
    some_hash = Hash.new
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    requirements_met = tracker_http_version.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_responds_to_track_data
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    responds_to_track_data = tracker_http_version.respond_to?(:track_data)

    assert_equal(true, responds_to_track_data)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_track_data_does_not_mutate_argument_hash
    expected_data_hash = {'HTTP_VERSION' => 'version'}
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    
    tracker_http_version.track_data(expected_data_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_responds_to_least_frequent
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    responds_to_least_frequent = tracker_http_version.respond_to?(:least_frequent)

    assert_equal(true, responds_to_least_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_least_frequent_returns_array
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    least_frequent = tracker_http_version.least_frequent

    assert_instance_of(Array, least_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_least_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    least_frequent = tracker_http_version.least_frequent

    assert_equal([], least_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_least_frequent_returns_array_with_expected_least_frequent_http_version_instances
    request_data_hashes = [
      {'HTTP_VERSION' => 'HTTP/1.0'},
      {'HTTP_VERSION' => 'HTTP/0.9'},
      {'HTTP_VERSION' => 'HTTP/1.0'}
    ]
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    request_data_hashes.each do |request_data_hash|
      tracker_http_version.track_data(request_data_hash)
    end

    least_frequent = tracker_http_version.least_frequent

    assert_equal(1, least_frequent.size)
    assert_includes(least_frequent, RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9'))
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_least_frequent_returns_array_with_all_least_frequent_http_version_instances_with_identical_frequency
    request_data_hashes = [
      {'HTTP_VERSION' => 'HTTP/0.9'},
      {'HTTP_VERSION' => 'HTTP/1.1'},
      {'HTTP_VERSION' => 'HTTP/1.1'},
      {'HTTP_VERSION' => 'HTTP/2.0'}
    ]
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    request_data_hashes.each do |request_data_hash|
      tracker_http_version.track_data(request_data_hash)
    end

    least_frequent = tracker_http_version.least_frequent

    assert_equal(2, least_frequent.size)
    assert_includes(least_frequent, RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9'))
    assert_includes(least_frequent, RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0'))
    refute_includes(least_frequent, RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.1'))
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_responds_to_most_frequent
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    responds_to_most_frequent = tracker_http_version.respond_to?(:most_frequent)

    assert_equal(true, responds_to_most_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_most_frequent_returns_array
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    most_frequent = tracker_http_version.most_frequent

    assert_instance_of(Array, most_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_most_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    most_frequent = tracker_http_version.most_frequent

    assert_equal([], most_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_most_frequent_returns_array_with_expected_most_frequent_http_version_instances
    request_data_hashes = [
      {'HTTP_VERSION' => 'HTTP/1.0'},
      {'HTTP_VERSION' => 'HTTP/2.0'},
      {'HTTP_VERSION' => 'HTTP/0.9'},
      {'HTTP_VERSION' => 'HTTP/2.0'}
    ]
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    request_data_hashes.each do |request_data_hash|
      tracker_http_version.track_data(request_data_hash)
    end

    most_frequent = tracker_http_version.most_frequent

    assert_equal(1, most_frequent.size)
    assert_includes(most_frequent, RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0'))
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_most_frequent_returns_array_with_all_most_frequent_http_version_instances_with_identical_frequency
    request_data_hashes = [
      {'HTTP_VERSION' => 'HTTP/0.9'},
      {'HTTP_VERSION' => 'HTTP/0.9'},
      {'HTTP_VERSION' => 'HTTP/1.1'},
      {'HTTP_VERSION' => 'HTTP/1.1'},
      {'HTTP_VERSION' => 'HTTP/2.0'}
    ]
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    request_data_hashes.each do |request_data_hash|
      tracker_http_version.track_data(request_data_hash)
    end

    most_frequent = tracker_http_version.most_frequent

    assert_equal(2, most_frequent.size)
    assert_includes(most_frequent, RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9'))
    assert_includes(most_frequent, RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.1'))
    refute_includes(most_frequent, RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0'))
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_responds_to_all
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    responds_to_all = tracker_http_version.respond_to?(:all)

    assert_equal(true, responds_to_all)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_all_returns_array
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    all = tracker_http_version.all

    assert_instance_of(Array, all)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_all_returns_empty_array_when_no_data_tracked_yet
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    all = tracker_http_version.all

    assert_equal([], all)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_all_returns_array_with_all_tracked_http_version_instances
    request_data_hashes = [
      {'HTTP_VERSION' => 'HTTP/2.0'},
      {'HTTP_VERSION' => 'HTTP/1.0'},
      {'HTTP_VERSION' => 'HTTP/1.0'},
      {'HTTP_VERSION' => 'HTTP/0.9'},
      {'HTTP_VERSION' => 'HTTP/0.9'},
      {'HTTP_VERSION' => 'HTTP/0.9'}
    ]
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    request_data_hashes.each do |request_data_hash|
      tracker_http_version.track_data(request_data_hash)
    end

    all = tracker_http_version.all

    assert_equal(3, all.size)
    assert_includes(all, RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0'))
    assert_includes(all, RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.0'))
    assert_includes(all, RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9'))
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_parses_http_version_string_into_correct_major_and_minor_version
    http_versions_request_hash = {'HTTP_VERSION' => 'HTTP/1.0'}
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    tracker_http_version.track_data(http_versions_request_hash)
    all = tracker_http_version.all
    tracked_http_version_instance = all.first

    assert_equal(1, all.size)
    assert_equal(1, tracked_http_version_instance.major)
    assert_equal(0, tracked_http_version_instance.minor)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_responds_to_has_ranking?
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    responds_to_has_ranking = tracker_http_version.respond_to?(:has_ranking?)

    assert_equal(true, responds_to_has_ranking)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_has_ranking_returns_false_when_ranking_http_version_has_not_yet_been_determined
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    has_ranking = tracker_http_version.has_ranking?

    assert_equal(false, has_ranking)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_has_ranking_returns_true_when_ranking_http_version_has_been_determined
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new
    request_data_hash = {'HTTP_VERSION' => 'HTTP/2.0'}
    tracker_http_version.track_data(request_data_hash)

    has_ranking = tracker_http_version.has_ranking?

    assert_equal(true, has_ranking)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_responds_to_lowest
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    responds_to_lowest = tracker_http_version.respond_to?(:lowest)

    assert_equal(true, responds_to_lowest)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_lowest_returns_nil_when_has_ranking_returns_false
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    has_ranking = tracker_http_version.has_ranking?
    lowest = tracker_http_version.lowest

    assert_equal(false, has_ranking)
    assert_nil(lowest)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_lowest_returns_lowest_ranking_http_version_instance_when_has_ranking_returns_true
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new
    request_data_hash = {'HTTP_VERSION' => 'HTTP/0.9'}
    tracker_http_version.track_data(request_data_hash)

    has_ranking = tracker_http_version.has_ranking?
    lowest = tracker_http_version.lowest

    assert_equal(true, has_ranking)
    assert_equal(RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9'), lowest)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_lowest_returns_expected_lowest_ranking_http_version_instance
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new
    request_data_hashes = [
      {'HTTP_VERSION' => 'HTTP/1.1'},
      {'HTTP_VERSION' => 'HTTP/2.0'},
      {'HTTP_VERSION' => 'HTTP/0.9'},
      {'HTTP_VERSION' => 'HTTP/1.0'}
    ]

    request_data_hashes.each do |request_data_hash|
      tracker_http_version.track_data(request_data_hash)
    end

    lowest = tracker_http_version.lowest

    assert_equal(RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9'), lowest)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_responds_to_highest
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    responds_to_highest = tracker_http_version.respond_to?(:highest)

    assert_equal(true, responds_to_highest)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_highest_returns_nil_when_has_ranking_returns_false
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new

    has_ranking = tracker_http_version.has_ranking?
    highest = tracker_http_version.highest

    assert_equal(false, has_ranking)
    assert_nil(highest)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_highest_returns_highest_ranking_http_version_instance_when_has_ranking_returns_true
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new
    request_data_hash = {'HTTP_VERSION' => 'HTTP/2.0'}
    tracker_http_version.track_data(request_data_hash)

    has_ranking = tracker_http_version.has_ranking?
    highest = tracker_http_version.highest

    assert_equal(true, has_ranking)
    assert_equal(RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0'), highest)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_highest_returns_expected_highest_ranking_http_version_instance
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new
    request_data_hashes = [
      {'HTTP_VERSION' => 'HTTP/1.1'},
      {'HTTP_VERSION' => 'HTTP/2.0'},
      {'HTTP_VERSION' => 'HTTP/0.9'},
      {'HTTP_VERSION' => 'HTTP/1.0'}
    ]

    request_data_hashes.each do |request_data_hash|
      tracker_http_version.track_data(request_data_hash)
    end

    highest = tracker_http_version.highest

    assert_equal(RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0'), highest)
  end

  def test_that_RackUsageTracking_TrackerHttpVersion_lowest_and_highest_return_the_same_ranking_http_version_when_only_one_http_version_tracked_yet
    tracker_http_version = RackUsageTracking::TrackerHttpVersion.new
    request_data_hash = {'HTTP_VERSION' => 'HTTP/1.0'}
    tracker_http_version.track_data(request_data_hash)

    lowest = tracker_http_version.lowest
    highest = tracker_http_version.highest

    assert_equal(RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.0'), lowest)
    assert_equal(RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.0'), highest)
    assert_equal(lowest, highest)
  end
end
