require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageTrackingTrackerPathTest < Minitest::Test
  def test_that_RackUsageTracking_TrackerPath_accessible_when_middleware_required
    tracker_path = defined?(RackUsageTracking::TrackerPath)

    assert(tracker_path)
  end

  def test_that_RackUsageTracking_TrackerPath_is_subclass_of_Tracker
    is_subclass_of_tracker = (RackUsageTracking::TrackerPath < RackUsageTracking::Tracker)

    assert_equal(true, is_subclass_of_tracker)
  end

  def test_that_RackUsageTracking_TrackerPath_requirements_met_takes_single_hash_as_argument_and_returns_false
    some_hash = Hash.new
    tracker_path = RackUsageTracking::TrackerPath.new

    requirements_met = tracker_path.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerPath_requirements_met_does_not_mutate_argument_hash
    some_hash = {'Iron' => 'Man', 'Spider' => 'Boy'}
    tracker_path = RackUsageTracking::TrackerPath.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_path.requirements_met?(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerPath_requirements_met_returns_true_when_argument_hash_contains_expected_data
    expected_data_hash = { 'PATH_INFO' => 'path' }
    tracker_path = RackUsageTracking::TrackerPath.new

    requirements_met = tracker_path.requirements_met?(expected_data_hash)

    assert_equal(true, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerPath_requirements_met_returns_false_when_argument_hash_does_not_contain_expected_data
    some_hash = Hash.new
    tracker_path = RackUsageTracking::TrackerPath.new

    requirements_met = tracker_path.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerPath_responds_to_track_data
    tracker_path = RackUsageTracking::TrackerPath.new

    responds_to_track_data = tracker_path.respond_to?(:track_data)

    assert_equal(true, responds_to_track_data)
  end

  def test_that_RackUsageTracking_TrackerPath_track_data_does_not_mutate_argument_hash
    expected_data_hash = {'PATH_INFO' => '/books'}
    tracker_path = RackUsageTracking::TrackerPath.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    
    tracker_path.track_data(expected_data_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end
  
  def test_that_RackUsageTracking_TrackerPath_responds_to_least_frequent
    tracker_path = RackUsageTracking::TrackerPath.new

    responds_to_least_frequent = tracker_path.respond_to?(:least_frequent)

    assert_equal(true, responds_to_least_frequent)
  end

  def test_that_RackUsageTracking_TrackerPath_least_frequent_returns_array
    tracker_path = RackUsageTracking::TrackerPath.new

    least_frequent = tracker_path.least_frequent

    assert_instance_of(Array, least_frequent)
  end

  def test_that_RackUsageTracking_TrackerPath_least_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_path = RackUsageTracking::TrackerPath.new

    least_frequent = tracker_path.least_frequent

    assert_equal([], least_frequent)
  end

  def test_that_RackUsageTracking_TrackerPath_least_frequent_returns_array_with_expected_least_frequent_objects
    request_data_hashes = [
      {'PATH_INFO' => '/books'},
      {'PATH_INFO' => '/toys'},
      {'PATH_INFO' => '/books'},
    ]
    tracker_path = RackUsageTracking::TrackerPath.new

    request_data_hashes.each do |request_data_hash|
      tracker_path.track_data(request_data_hash)
    end

    least_frequent = tracker_path.least_frequent

    assert_equal(%w(/toys), least_frequent)
  end

  def test_that_RackUsageTracking_TrackerPath_least_frequent_returns_array_with_all_least_frequent_objects_with_identical_frequency
    request_data_hashes = [
      {'PATH_INFO' => '/apples'},
      {'PATH_INFO' => '/apples'},
      {'PATH_INFO' => '/oranges'},
      {'PATH_INFO' => '/oranges'},
      {'PATH_INFO' => '/oranges'},
      {'PATH_INFO' => '/mangos'},
      {'PATH_INFO' => '/mangos'}
    ]
    tracker_path = RackUsageTracking::TrackerPath.new

    request_data_hashes.each do |request_data_hash|
      tracker_path.track_data(request_data_hash)
    end

    least_frequent = tracker_path.least_frequent

    assert_equal(2, least_frequent.size)
    assert_includes(least_frequent, '/apples')
    assert_includes(least_frequent, '/mangos')
    refute_includes(least_frequent, '/oranges')
  end

  def test_that_RackUsageTracking_TrackerPath_least_frequent_returns_array_with_dupped_least_frequent_objects
    path_info_string = '/books/science'

    request_data_hashes = [
      { 'PATH_INFO' => path_info_string },
      { 'PATH_INFO' => path_info_string },
      { 'PATH_INFO' => path_info_string }
    ]
    tracker_path = RackUsageTracking::TrackerPath.new

    request_data_hashes.each do |request_data_hash|
      tracker_path.track_data(request_data_hash)
    end

    least_frequent = tracker_path.least_frequent

    least_frequent.each do |least_frequent_object|    
      refute_same(least_frequent_object, path_info_string)
    end
  end

  def test_that_RackUsageTracking_TrackerPath_responds_to_most_frequent
    tracker_path = RackUsageTracking::TrackerPath.new

    responds_to_most_frequent = tracker_path.respond_to?(:most_frequent)

    assert_equal(true, responds_to_most_frequent)
  end

  def test_that_RackUsageTracking_TrackerPath_most_frequent_returns_array
    tracker_path = RackUsageTracking::TrackerPath.new

    most_frequent = tracker_path.most_frequent

    assert_instance_of(Array, most_frequent)
  end

  def test_that_RackUsageTracking_TrackerPath_most_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_path = RackUsageTracking::TrackerPath.new

    most_frequent = tracker_path.most_frequent

    assert_equal([], most_frequent)
  end

  def test_that_RackUsageTracking_TrackerPath_most_frequent_returns_array_with_expected_most_frequent_objects
    request_data_hashes = [
      {'PATH_INFO' => '/books/science'},
      {'PATH_INFO' => '/books/crafting'},
      {'PATH_INFO' => '/books/computers'},
      {'PATH_INFO' => '/books/science'}
    ]
    tracker_path = RackUsageTracking::TrackerPath.new

    request_data_hashes.each do |request_data_hash|
      tracker_path.track_data(request_data_hash)
    end

    most_frequent = tracker_path.most_frequent

    assert_equal(%w(/books/science), most_frequent)
  end

  def test_that_RackUsageTracking_TrackerPath_most_frequent_returns_array_with_all_most_frequent_objects_with_identical_frequency
    request_data_hashes = [
      {'PATH_INFO' => '/toys/baby'},
      {'PATH_INFO' => '/toys/baby'},
      {'PATH_INFO' => '/toys/adults'},
      {'PATH_INFO' => '/toys/adults'},
      {'PATH_INFO' => '/toys/elderly'}
    ]
    tracker_path = RackUsageTracking::TrackerPath.new

    request_data_hashes.each do |request_data_hash|
      tracker_path.track_data(request_data_hash)
    end

    most_frequent = tracker_path.most_frequent

    assert_equal(2, most_frequent.size)
    assert_includes(most_frequent, '/toys/baby')
    assert_includes(most_frequent, '/toys/adults')
    refute_includes(most_frequent, '/toys/elderly')
  end

  def test_that_RackUsageTracking_TrackerPath_most_frequent_returns_array_with_dupped_most_frequent_objects
    path_info_string = '/users/Trish88'

    request_data_hashes = [
      {'PATH_INFO' => path_info_string},
      {'PATH_INFO' => path_info_string},
      {'PATH_INFO' => path_info_string}
    ]
    tracker_path = RackUsageTracking::TrackerPath.new

    request_data_hashes.each do |request_data_hash|
      tracker_path.track_data(request_data_hash)
    end

    most_frequent = tracker_path.most_frequent

    most_frequent.each do |most_frequent_object|    
      refute_same(most_frequent_object, path_info_string)
    end
  end

  def test_that_RackUsageTracking_TrackerPath_responds_to_has_longest?
    tracker_path = RackUsageTracking::TrackerPath.new

    responds_to_has_longest = tracker_path.respond_to?(:has_longest?)

    assert_equal(true, responds_to_has_longest)
  end

  def test_that_RackUsageTracking_TrackerPath_has_longest_returns_false_when_longest_path_has_not_yet_been_determined
    tracker_path = RackUsageTracking::TrackerPath.new

    has_longest = tracker_path.has_longest?

    assert_equal(false, has_longest)
  end

  def test_that_RackUsageTracking_TrackerPath_has_longest_returns_true_when_longest_path_has_been_determined
    tracker_path = RackUsageTracking::TrackerPath.new
    request_data_hash = {'PATH_INFO' => '/clothes/men'}
    tracker_path.track_data(request_data_hash)

    has_longest = tracker_path.has_longest?

    assert_equal(true, has_longest)
  end

  def test_that_RackUsageTracking_TrackerPath_responds_to_longest
    tracker_path = RackUsageTracking::TrackerPath.new

    responds_to_longest = tracker_path.respond_to?(:longest)

    assert_equal(true, responds_to_longest)
  end

  def test_that_RackUsageTracking_TrackerPath_longest_returns_nil_when_has_longest_returns_false
    tracker_path = RackUsageTracking::TrackerPath.new

    has_longest = tracker_path.has_longest?
    longest = tracker_path.longest

    assert_equal(false, has_longest)
    assert_nil(longest)
  end

  def test_that_RackUsageTracking_TrackerPath_longest_returns_longest_path_when_has_longest_returns_true
    tracker_path = RackUsageTracking::TrackerPath.new
    request_data_hash = {'PATH_INFO' => '/clothes/children'}
    tracker_path.track_data(request_data_hash)

    has_longest = tracker_path.has_longest?
    longest = tracker_path.longest

    assert_equal(true, has_longest)
    assert_equal('/clothes/children', longest)
  end

  def test_that_RackUsageTracking_TrackerPath_longest_returns_expected_longest_path
    tracker_path = RackUsageTracking::TrackerPath.new
    request_data_hashes = [
      {'PATH_INFO' => '/clothes/pants'},
      {'PATH_INFO' => '/clothes/pants/children'},
      {'PATH_INFO' => '/clothes'},
      {'PATH_INFO' => '/clothes/pants/children/yellow'}
    ]

    request_data_hashes.each do |request_data_hash|
      tracker_path.track_data(request_data_hash)
    end

    longest = tracker_path.longest

    assert_equal('/clothes/pants/children/yellow', longest)
  end
end
