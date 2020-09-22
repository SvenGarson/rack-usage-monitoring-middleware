require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageTrackingTrackerHttpMethodTest < Minitest::Test
  def test_that_RackUsageTracking_TrackerHttpMethod_accessible_when_middleware_required
    tracker_http_method_accessible = defined?(RackUsageTracking::TrackerHttpMethod)

    assert(tracker_http_method_accessible)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_is_subclass_of_Tracker
    subclass_of_tracker = (RackUsageTracking::TrackerHttpMethod < RackUsageTracking::Tracker)

    assert_equal(true, subclass_of_tracker)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_requirements_met_takes_single_hash_as_argument_and_returns_false
    some_hash = Hash.new
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    requirements_met = tracker_http_method.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_requirements_met_does_not_mutate_argument_hash
    some_hash = {'Iron' => 'Man', 'Spider' => 'Boy'}
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_http_method.requirements_met?(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_requirements_met_returns_true_when_argument_hash_contains_expected_data
    expected_data_hash = { 'REQUEST_METHOD' => 'gimme' }
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    requirements_met = tracker_http_method.requirements_met?(expected_data_hash)

    assert_equal(true, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_requirements_met_returns_false_when_argument_hash_does_not_contain_expected_data
    some_hash = Hash.new
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    requirements_met = tracker_http_method.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_responds_to_track_data
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    responds_to_track_data = tracker_http_method.respond_to?(:track_data)

    assert_equal(true, responds_to_track_data)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_track_data_does_not_mutate_argument_hash
    some_hash = {'Aqua' => 'Man', 'Super' => 'Woman'}
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_http_method.track_data(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_responds_to_least_frequent
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    responds_to_least_frequent = tracker_http_method.respond_to?(:least_frequent)

    assert_equal(true, responds_to_least_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_least_frequent_returns_array
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    least_frequent = tracker_http_method.least_frequent

    assert_instance_of(Array, least_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_least_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    least_frequent = tracker_http_method.least_frequent

    assert_equal([], least_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_least_frequent_returns_array_with_expected_least_frequent_objects
    request_data_hashes = [
      {'REQUEST_METHOD' => 'GET'},
      {'REQUEST_METHOD' => 'GET'},
      {'REQUEST_METHOD' => 'GET'},
      {'REQUEST_METHOD' => 'POST'},
      {'REQUEST_METHOD' => 'DELETE'},
      {'REQUEST_METHOD' => 'POST'}
    ]
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    request_data_hashes.each do |request_data_hash|
      tracker_http_method.track_data(request_data_hash)
    end

    least_frequent = tracker_http_method.least_frequent

    assert_equal(%w(DELETE), least_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_least_frequent_returns_array_with_all_least_frequent_objects_with_identical_frequency
    request_data_hashes = [
      {'REQUEST_METHOD' => 'GET'},
      {'REQUEST_METHOD' => 'DELETE'},
      {'REQUEST_METHOD' => 'DELETE'},
      {'REQUEST_METHOD' => 'POST'}
    ]
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    request_data_hashes.each do |request_data_hash|
      tracker_http_method.track_data(request_data_hash)
    end

    least_frequent = tracker_http_method.least_frequent

    assert_equal(2, least_frequent.size)
    assert_includes(least_frequent, 'GET')
    assert_includes(least_frequent, 'POST')
    refute_includes(least_frequent, 'DELETE')
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_least_frequent_returns_array_with_dupped_least_frequent_objects
    request_method_get = 'get'

    request_data_hashes = [
      {'REQUEST_METHOD' => request_method_get},
      {'REQUEST_METHOD' => request_method_get},
      {'REQUEST_METHOD' => request_method_get}
    ]
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    request_data_hashes.each do |request_data_hash|
      tracker_http_method.track_data(request_data_hash)
    end

    least_frequent = tracker_http_method.least_frequent

    least_frequent.each do |least_frequent_object|    
      refute_same(least_frequent_object, request_method_get)
    end
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_responds_to_most_frequent
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    responds_to_most_frequent = tracker_http_method.respond_to?(:most_frequent)

    assert_equal(true, responds_to_most_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_most_frequent_returns_array
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    most_frequent = tracker_http_method.most_frequent

    assert_instance_of(Array, most_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_most_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    most_frequent = tracker_http_method.most_frequent

    assert_equal([], most_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_most_frequent_returns_array_with_expected_most_frequent_objects
    request_data_hashes = [
      {'REQUEST_METHOD' => 'GET'},
      {'REQUEST_METHOD' => 'GET'},
      {'REQUEST_METHOD' => 'POST'},
      {'REQUEST_METHOD' => 'POST'},
      {'REQUEST_METHOD' => 'DELETE'},
      {'REQUEST_METHOD' => 'GET'}
    ]
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    request_data_hashes.each do |request_data_hash|
      tracker_http_method.track_data(request_data_hash)
    end

    most_frequent = tracker_http_method.most_frequent

    assert_equal(%w(GET), most_frequent)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_most_frequent_returns_array_with_all_most_frequent_objects_with_identical_frequency
    request_data_hashes = [
      {'REQUEST_METHOD' => 'GET'},
      {'REQUEST_METHOD' => 'DELETE'},
      {'REQUEST_METHOD' => 'POST'},
      {'REQUEST_METHOD' => 'DELETE'},
      {'REQUEST_METHOD' => 'POST'}
    ]
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    request_data_hashes.each do |request_data_hash|
      tracker_http_method.track_data(request_data_hash)
    end

    most_frequent = tracker_http_method.most_frequent

    assert_equal(2, most_frequent.size)
    assert_includes(most_frequent, 'DELETE')
    assert_includes(most_frequent, 'POST')
    refute_includes(most_frequent, 'GET')
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_most_frequent_returns_array_with_dupped_most_frequent_objects
    request_method_get = 'get'

    request_data_hashes = [
      {'REQUEST_METHOD' => request_method_get},
      {'REQUEST_METHOD' => request_method_get},
      {'REQUEST_METHOD' => request_method_get}
    ]
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    request_data_hashes.each do |request_data_hash|
      tracker_http_method.track_data(request_data_hash)
    end

    most_frequent = tracker_http_method.most_frequent

    most_frequent.each do |most_frequent_object|    
      refute_same(most_frequent_object, request_method_get)
    end
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_responds_to_all
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    responds_to_all = tracker_http_method.respond_to?(:all)

    assert_equal(true, responds_to_all)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_all_returns_array
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    all = tracker_http_method.all

    assert_instance_of(Array, all)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_all_returns_empty_array_when_no_data_tracked_yet
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    all = tracker_http_method.all

    assert_equal([], all)
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_all_returns_array_with_all_tracked_objects
    request_data_hashes = [
      {'REQUEST_METHOD' => 'GET'},
      {'REQUEST_METHOD' => 'POST'},
      {'REQUEST_METHOD' => 'POST'},
      {'REQUEST_METHOD' => 'DELETE'},
      {'REQUEST_METHOD' => 'DELETE'},
      {'REQUEST_METHOD' => 'DELETE'}
    ]
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    request_data_hashes.each do |request_data_hash|
      tracker_http_method.track_data(request_data_hash)
    end

    all = tracker_http_method.all

    assert_equal(3, all.size)
    assert_includes(all, 'GET')
    assert_includes(all, 'POST')
    assert_includes(all, 'DELETE')
  end

  def test_that_RackUsageTracking_TrackerHttpMethod_all_returns_array_with_tracked_objects_dupped
    request_method_get = 'get'

    request_data_hashes = [
      {'REQUEST_METHOD' => request_method_get},
      {'REQUEST_METHOD' => request_method_get},
      {'REQUEST_METHOD' => request_method_get}
    ]
    tracker_http_method = RackUsageTracking::TrackerHttpMethod.new

    request_data_hashes.each do |request_data_hash|
      tracker_http_method.track_data(request_data_hash)
    end

    all = tracker_http_method.all

    all.each do |all_object|    
      refute_same(all_object, request_method_get)
    end
  end
end