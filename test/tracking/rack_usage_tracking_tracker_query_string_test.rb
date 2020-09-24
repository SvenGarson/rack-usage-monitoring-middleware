require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageTrackingTrackerQueryStringTest < Minitest::Test
  def test_that_RackUsageTracking_TrackerQueryString_accessible_when_middleware_required
    tracker_query_string = defined?(RackUsageTracking::TrackerQueryString)

    assert(tracker_query_string)
  end

  def test_that_RackUsageTracking_TrackerQueryString_is_subclass_of_Tracker
    is_subclass_of_tracker = (RackUsageTracking::TrackerQueryString < RackUsageTracking::Tracker)

    assert_equal(true, is_subclass_of_tracker)
  end

  def test_that_RackUsageTracking_TrackerQueryString_requirements_met_takes_single_hash_as_argument_and_returns_false
    some_hash = Hash.new
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    requirements_met = tracker_query_string.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerQueryString_requirements_met_does_not_mutate_argument_hash
    some_hash = {'Iron' => 'Man', 'Spider' => 'Boy'}
    tracker_query_string = RackUsageTracking::TrackerQueryString.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_query_string.requirements_met?(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerQueryString_requirements_met_returns_true_when_argument_hash_contains_expected_data
    expected_data_hash = { 'QUERY_STRING' => '?user=John77&choice=12345' }
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    requirements_met = tracker_query_string.requirements_met?(expected_data_hash)

    assert_equal(true, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerQueryString_requirements_met_returns_false_when_argument_hash_does_not_contain_expected_data
    some_hash = Hash.new
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    requirements_met = tracker_query_string.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerQueryString_responds_to_track_data
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    responds_to_track_data = tracker_query_string.respond_to?(:track_data)

    assert_equal(true, responds_to_track_data)
  end

  def test_that_RackUsageTracking_TrackerQueryString_track_data_does_not_mutate_argument_hash
    expected_data_hash = {'QUERY_STRING' => '?bob=omp'}
    tracker_query_string = RackUsageTracking::TrackerQueryString.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    
    tracker_query_string.track_data(expected_data_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerQueryString_responds_to_least_frequent
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    responds_to_least_frequent = tracker_query_string.respond_to?(:least_frequent)

    assert_equal(true, responds_to_least_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryString_least_frequent_returns_array
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    least_frequent = tracker_query_string.least_frequent

    assert_instance_of(Array, least_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryString_least_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    least_frequent = tracker_query_string.least_frequent

    assert_equal([], least_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryString_least_frequent_returns_array_with_expected_least_frequent_objects
    request_data_hashes = [
      {'QUERY_STRING' => '?user=John88'},
      {'QUERY_STRING' => '?choice=12345'},
      {'QUERY_STRING' => '?user=John88'},
    ]
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_string.track_data(request_data_hash)
    end

    least_frequent = tracker_query_string.least_frequent

    assert_equal(%w(?choice=12345), least_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryString_least_frequent_returns_array_with_all_least_frequent_objects_with_identical_frequency
    request_data_hashes = [
      {'QUERY_STRING' => '?color=red'},
      {'QUERY_STRING' => '?color=red'},
      {'QUERY_STRING' => '?age=28'},
      {'QUERY_STRING' => '?age=28'},
      {'QUERY_STRING' => '?age=28'},
      {'QUERY_STRING' => '?fear=spiders'},
      {'QUERY_STRING' => '?fear=spiders'}
    ]
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_string.track_data(request_data_hash)
    end

    least_frequent = tracker_query_string.least_frequent

    assert_equal(2, least_frequent.size)
    assert_includes(least_frequent, '?color=red')
    assert_includes(least_frequent, '?fear=spiders')
    refute_includes(least_frequent, '?age=28')
  end

  def test_that_RackUsageTracking_TrackerQueryString_least_frequent_returns_array_with_dupped_least_frequent_objects
    query_string = '?song=thunderstruck'

    request_data_hashes = [
      { 'QUERY_STRING' => query_string },
      { 'QUERY_STRING' => query_string },
      { 'QUERY_STRING' => query_string }
    ]
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_string.track_data(request_data_hash)
    end

    least_frequent = tracker_query_string.least_frequent

    least_frequent.each do |least_frequent_object|    
      refute_same(least_frequent_object, query_string)
    end
  end

  def test_that_RackUsageTracking_TrackerQueryString_responds_to_most_frequent
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    responds_to_most_frequent = tracker_query_string.respond_to?(:most_frequent)

    assert_equal(true, responds_to_most_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryString_most_frequent_returns_array
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    most_frequent = tracker_query_string.most_frequent

    assert_instance_of(Array, most_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryString_most_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    most_frequent = tracker_query_string.most_frequent

    assert_equal([], most_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryString_most_frequent_returns_array_with_expected_most_frequent_objects
    request_data_hashes = [
      {'QUERY_STRING' => '?wood=solid'},
      {'QUERY_STRING' => '?water=liquid'},
      {'QUERY_STRING' => '?slime=gooey'},
      {'QUERY_STRING' => '?wood=solid'}
    ]
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_string.track_data(request_data_hash)
    end

    most_frequent = tracker_query_string.most_frequent

    assert_equal(%w(?wood=solid), most_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryString_most_frequent_returns_array_with_all_most_frequent_objects_with_identical_frequency
    request_data_hashes = [
      {'QUERY_STRING' => '?name=Johnathan'},
      {'QUERY_STRING' => '?name=Johnathan'},
      {'QUERY_STRING' => '?age=43'},
      {'QUERY_STRING' => '?age=43'},
      {'QUERY_STRING' => '?color=black'}
    ]
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_string.track_data(request_data_hash)
    end

    most_frequent = tracker_query_string.most_frequent

    assert_equal(2, most_frequent.size)
    assert_includes(most_frequent, '?name=Johnathan')
    assert_includes(most_frequent, '?age=43')
    refute_includes(most_frequent, '?color=black')
  end

  def test_that_RackUsageTracking_TrackerQueryString_most_frequent_returns_array_with_dupped_most_frequent_objects
    query_string = '?choice=premium'

    request_data_hashes = [
      {'QUERY_STRING' => query_string},
      {'QUERY_STRING' => query_string},
      {'QUERY_STRING' => query_string}
    ]
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_string.track_data(request_data_hash)
    end

    most_frequent = tracker_query_string.most_frequent

    most_frequent.each do |most_frequent_object|    
      refute_same(most_frequent_object, query_string)
    end
  end

  def test_that_RackUsageTracking_TrackerQueryString_responds_to_has_longest?
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    responds_to_has_longest = tracker_query_string.respond_to?(:has_longest?)

    assert_equal(true, responds_to_has_longest)
  end

  def test_that_RackUsageTracking_TrackerQueryString_has_longest_returns_false_when_longest_query_string_has_not_yet_been_determined
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    has_longest = tracker_query_string.has_longest?

    assert_equal(false, has_longest)
  end

  def test_that_RackUsageTracking_TrackerQueryString_has_longest_returns_true_when_longest_query_string_has_been_determined
    tracker_query_string = RackUsageTracking::TrackerQueryString.new
    request_data_hash = {'QUERY_STRING' => '?super_mario=plumber'}
    tracker_query_string.track_data(request_data_hash)

    has_longest = tracker_query_string.has_longest?

    assert_equal(true, has_longest)
  end

  def test_that_RackUsageTracking_TrackerQueryString_responds_to_longest
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    responds_to_longest = tracker_query_string.respond_to?(:longest)

    assert_equal(true, responds_to_longest)
  end

  def test_that_RackUsageTracking_TrackerQueryString_longest_returns_nil_when_has_longest_returns_false
    tracker_query_string = RackUsageTracking::TrackerQueryString.new

    has_longest = tracker_query_string.has_longest?
    longest = tracker_query_string.longest

    assert_equal(false, has_longest)
    assert_nil(longest)
  end

  def test_that_RackUsageTracking_TrackerQueryString_longest_returns_longest_query_string_when_has_longest_returns_true
    tracker_query_string = RackUsageTracking::TrackerQueryString.new
    request_data_hash = {'QUERY_STRING' => '?category=bikes'}
    tracker_query_string.track_data(request_data_hash)

    has_longest = tracker_query_string.has_longest?
    longest = tracker_query_string.longest

    assert_equal(true, has_longest)
    assert_equal('?category=bikes', longest)
  end

  def test_that_RackUsageTracking_TrackerQueryString_longest_returns_expected_longest_query_string
    tracker_query_string = RackUsageTracking::TrackerQueryString.new
    request_data_hashes = [
      {'QUERY_STRING' => '?choice=PC'},
      {'QUERY_STRING' => '?country=germany'},
      {'QUERY_STRING' => '?size=XXL'},
      {'QUERY_STRING' => '?description=tool&condition=mint'}
    ]

    request_data_hashes.each do |request_data_hash|
      tracker_query_string.track_data(request_data_hash)
    end

    longest = tracker_query_string.longest

    assert_equal('?description=tool&condition=mint', longest)
  end
end
