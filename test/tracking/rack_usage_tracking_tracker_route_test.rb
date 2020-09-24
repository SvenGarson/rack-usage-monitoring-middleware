require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageTrackingTrackerRouteTest < Minitest::Test
  def test_that_RackUsageTracking_TrackerRoute_accessible_when_middleware_required
    tracker_route = defined?(RackUsageTracking::TrackerRoute)

    assert(tracker_route)
  end


  def test_that_RackUsageTracking_TrackerRoute_is_subclass_of_Tracker
    is_subclass_of_tracker = (RackUsageTracking::TrackerRoute < RackUsageTracking::Tracker)

    assert_equal(true, is_subclass_of_tracker)
  end

  def test_that_RackUsageTracking_TrackerRoute_requirements_met_takes_single_hash_as_argument_and_returns_false
    some_hash = Hash.new
    tracker_route = RackUsageTracking::TrackerRoute.new

    requirements_met = tracker_route.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerRoute_requirements_met_does_not_mutate_argument_hash
    some_hash = {'Iron' => 'Man', 'Spider' => 'Boy'}
    tracker_route = RackUsageTracking::TrackerRoute.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_route.requirements_met?(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerRoute_requirements_met_returns_true_when_argument_hash_contains_expected_data
    expected_data_hash = {
      'PATH_INFO'    => 'path',
      'QUERY_STRING' => 'query'
    }
    tracker_route = RackUsageTracking::TrackerRoute.new

    requirements_met = tracker_route.requirements_met?(expected_data_hash)

    assert_equal(true, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerRoute_requirements_met_returns_false_when_argument_hash_does_not_contain_expected_data
    some_hash = Hash.new
    tracker_route = RackUsageTracking::TrackerRoute.new

    requirements_met = tracker_route.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerRoute_responds_to_track_data
    tracker_route = RackUsageTracking::TrackerRoute.new

    responds_to_track_data = tracker_route.respond_to?(:track_data)

    assert_equal(true, responds_to_track_data)
  end

  def test_that_RackUsageTracking_TrackerRoute_track_data_does_not_mutate_argument_hash
    expected_data_hash = {
      'PATH_INFO'    => 'path',
      'QUERY_STRING' => 'query'
    }
    tracker_route = RackUsageTracking::TrackerRoute.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    
    tracker_route.track_data(expected_data_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerRoute_responds_to_least_frequent
    tracker_route = RackUsageTracking::TrackerRoute.new

    responds_to_least_frequent = tracker_route.respond_to?(:least_frequent)

    assert_equal(true, responds_to_least_frequent)
  end

  def test_that_RackUsageTracking_TrackerRoute_least_frequent_returns_array
    tracker_route = RackUsageTracking::TrackerRoute.new

    least_frequent = tracker_route.least_frequent

    assert_instance_of(Array, least_frequent)
  end

  def test_that_RackUsageTracking_TrackerRoute_least_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_route = RackUsageTracking::TrackerRoute.new

    least_frequent = tracker_route.least_frequent

    assert_equal([], least_frequent)
  end

  def test_that_RackUsageTracking_TrackerRoute_least_frequent_returns_array_with_expected_least_frequent_objects
    request_data_hashes = [
      { 'PATH_INFO' => '/books', 'QUERY_STRING' => 'category=science' },
      { 'PATH_INFO' => '/toys',  'QUERY_STRING' => 'category=baby' },
      { 'PATH_INFO' => '/books', 'QUERY_STRING' => 'category=science' }
    ]
    tracker_route = RackUsageTracking::TrackerRoute.new

    request_data_hashes.each do |request_data_hash|
      tracker_route.track_data(request_data_hash)
    end

    least_frequent = tracker_route.least_frequent

    assert_equal(%w(/toys?category=baby), least_frequent)
  end

  def test_that_RackUsageTracking_TrackerRoute_least_frequent_returns_array_with_all_least_frequent_objects_with_identical_frequency
    request_data_hashes = [
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=IronMan' },
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=IronMan' },
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=Ice' },
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=Ice' },
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=Ice' },
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=MasterAndCommander' },
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=MasterAndCommander' }
    ]
    tracker_route = RackUsageTracking::TrackerRoute.new

    request_data_hashes.each do |request_data_hash|
      tracker_route.track_data(request_data_hash)
    end

    least_frequent = tracker_route.least_frequent

    assert_equal(2, least_frequent.size)
    assert_includes(least_frequent, '/movies?name=IronMan')
    assert_includes(least_frequent, '/movies?name=MasterAndCommander')
    refute_includes(least_frequent, '/movies?name=Ice')
  end

  def test_that_RackUsageTracking_TrackerRoute_least_frequent_returns_array_with_dupped_least_frequent_objects
    path = '/games'
    query_string = '?title=Monopoly'

    request_data_hashes = [
      { 'PATH_INFO' => path, 'QUERY_STRING' => query_string },
      { 'PATH_INFO' => path, 'QUERY_STRING' => query_string },
      { 'PATH_INFO' => path, 'QUERY_STRING' => query_string }
    ]
    tracker_route = RackUsageTracking::TrackerRoute.new

    request_data_hashes.each do |request_data_hash|
      tracker_route.track_data(request_data_hash)
    end

    least_frequent = tracker_route.least_frequent

    least_frequent.each do |least_frequent_object|    
      refute_same(least_frequent_object, path)
      refute_same(least_frequent_object, query_string)
    end
  end

  def test_that_RackUsageTracking_TrackerRoute_responds_to_most_frequent
    tracker_route = RackUsageTracking::TrackerRoute.new

    responds_to_most_frequent = tracker_route.respond_to?(:most_frequent)

    assert_equal(true, responds_to_most_frequent)
  end

  def test_that_RackUsageTracking_TrackerRoute_most_frequent_returns_array
    tracker_route = RackUsageTracking::TrackerRoute.new

    most_frequent = tracker_route.most_frequent

    assert_instance_of(Array, most_frequent)
  end

  def test_that_RackUsageTracking_TrackerRoute_most_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_route = RackUsageTracking::TrackerRoute.new

    most_frequent = tracker_route.most_frequent

    assert_equal([], most_frequent)
  end

  def test_that_RackUsageTracking_TrackerRoute_most_frequent_returns_array_with_expected_most_frequent_objects
    request_data_hashes = [
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=Inception' },
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=Batman' },
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=Mr.Bean' },
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=Inception' }
    ]
    tracker_route = RackUsageTracking::TrackerRoute.new

    request_data_hashes.each do |request_data_hash|
      tracker_route.track_data(request_data_hash)
    end

    most_frequent = tracker_route.most_frequent

    assert_equal(%w(/movies?name=Inception), most_frequent)
  end

  def test_that_RackUsageTracking_TrackerRoute_most_frequent_returns_array_with_all_most_frequent_objects_with_identical_frequency
    request_data_hashes = [
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=Inception' },
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=Inception' },
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=RED' },
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=RED' },
      { 'PATH_INFO' => '/movies', 'QUERY_STRING' => 'name=LastSamurai' }
    ]
    tracker_route = RackUsageTracking::TrackerRoute.new

    request_data_hashes.each do |request_data_hash|
      tracker_route.track_data(request_data_hash)
    end

    most_frequent = tracker_route.most_frequent

    assert_equal(2, most_frequent.size)
    assert_includes(most_frequent, '/movies?name=Inception')
    assert_includes(most_frequent, '/movies?name=RED')
    refute_includes(most_frequent, '/movies?name=LastSamurai')
  end

  def test_that_RackUsageTracking_TrackerRoute_most_frequent_returns_array_with_dupped_most_frequent_objects
    path = '/tools'
    query_string = '?name=hammer'

    request_data_hashes = [
      { 'PATH_INFO' => path, 'QUERY_STRING' => query_string },
      { 'PATH_INFO' => path, 'QUERY_STRING' => query_string },
      { 'PATH_INFO' => path, 'QUERY_STRING' => query_string },
    ]
    tracker_route = RackUsageTracking::TrackerRoute.new

    request_data_hashes.each do |request_data_hash|
      tracker_route.track_data(request_data_hash)
    end

    most_frequent = tracker_route.most_frequent

    most_frequent.each do |most_frequent_object|    
      refute_same(most_frequent_object, path)
      refute_same(most_frequent_object, query_string)
    end
  end

  def test_that_RackUsageTracking_TrackerRoute_responds_to_has_longest?
    tracker_route = RackUsageTracking::TrackerRoute.new

    responds_to_has_longest = tracker_route.respond_to?(:has_longest?)

    assert_equal(true, responds_to_has_longest)
  end

  def test_that_RackUsageTracking_TrackerRoute_has_longest_returns_false_when_longest_route_has_not_yet_been_determined
    tracker_route = RackUsageTracking::TrackerRoute.new

    has_longest = tracker_route.has_longest?

    assert_equal(false, has_longest)
  end

  def test_that_RackUsageTracking_TrackerRoute_has_longest_returns_true_when_longest_route_has_been_determined
    tracker_route = RackUsageTracking::TrackerRoute.new
    request_data_hash = { 'PATH_INFO' => '/files', 'QUERY_STRING' => 'extension=png' }
    tracker_route.track_data(request_data_hash)

    has_longest = tracker_route.has_longest?

    assert_equal(true, has_longest)
  end

  def test_that_RackUsageTracking_TrackerRoute_responds_to_longest
    tracker_route = RackUsageTracking::TrackerRoute.new

    responds_to_longest = tracker_route.respond_to?(:longest)

    assert_equal(true, responds_to_longest)
  end

  def test_that_RackUsageTracking_TrackerRoute_longest_returns_nil_when_has_longest_returns_false
    tracker_route = RackUsageTracking::TrackerRoute.new

    has_longest = tracker_route.has_longest?
    longest = tracker_route.longest

    assert_equal(false, has_longest)
    assert_nil(longest)
  end

  def test_that_RackUsageTracking_TrackerRoute_longest_returns_longest_route_when_has_longest_returns_true
    tracker_route = RackUsageTracking::TrackerRoute.new
    request_data_hash = { 'PATH_INFO' => '/files', 'QUERY_STRING' => 'extension=png' }
    tracker_route.track_data(request_data_hash)

    has_longest = tracker_route.has_longest?
    longest = tracker_route.longest

    assert_equal(true, has_longest)
    assert_equal('/files?extension=png', longest)
  end

  def test_that_RackUsageTracking_TrackerRoute_longest_returns_expected_longest_route
    tracker_route = RackUsageTracking::TrackerRoute.new
    request_data_hashes = [
      { 'PATH_INFO' => '/files', 'QUERY_STRING' => 'filename=my_notes' },
      { 'PATH_INFO' => '/files', 'QUERY_STRING' => 'filename=best_movies' },
      { 'PATH_INFO' => '/files', 'QUERY_STRING' => 'filename=todo' },
      { 'PATH_INFO' => '/files', 'QUERY_STRING' => 'filename=commute_music_list' }
    ]

    request_data_hashes.each do |request_data_hash|
      tracker_route.track_data(request_data_hash)
    end

    longest = tracker_route.longest

    assert_equal('/files?filename=commute_music_list', longest)
  end

  def test_that_RackUsageTracking_TrackerRoute_uses_query_string_as_is_when_it_is_already_prefixed_with_a_single_question_mark
    request_data_hash = { 'PATH_INFO' => '/books', 'QUERY_STRING' => '?name=MobyDick' }
    tracker_route = RackUsageTracking::TrackerRoute.new

    tracker_route.track_data(request_data_hash)
    least_frequent = tracker_route.least_frequent

    assert_equal(%w(/books?name=MobyDick), least_frequent)
  end

  def test_that_RackUsageTracking_TrackerRoute_prefixes_query_string_with_single_question_mark_when_it_is_not_already
    request_data_hash = { 'PATH_INFO' => '/books', 'QUERY_STRING' => 'name=MobyDick' }
    tracker_route = RackUsageTracking::TrackerRoute.new

    tracker_route.track_data(request_data_hash)
    least_frequent = tracker_route.least_frequent

    assert_equal(%w(/books?name=MobyDick), least_frequent)
  end
end

=begin
  - route has single '?' if query string is NOT led by '?' ==> NONE ADDED
  - route has single '?' if query string is led by '?'     ==>  YES ADDED
=end