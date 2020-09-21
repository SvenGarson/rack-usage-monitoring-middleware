require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageTrackingTrackerRequestTest < Minitest::Test
  def test_that_RackUsageTracking_TrackerRequest_accessible_when_middleware_required
    tracker_request_accessible = defined?(RackUsageTracking::TrackerRequest)

    assert(tracker_request_accessible)
  end

  def test_that_RackUsageTracking_TrackerRequest_is_subclass_of_Tracker
    subclass_of_tracker = (RackUsageTracking::TrackerRequest < RackUsageTracking::Tracker)

    assert_equal(true, subclass_of_tracker)
  end

  def test_that_RackUsageTracking_TrackerRequest_requirements_met_takes_single_hash_as_argument_and_returns_true
    some_hash = Hash.new
    tracker_request = RackUsageTracking::TrackerRequest.new

    requirements_met = tracker_request.requirements_met?(some_hash)

    assert_equal(true, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerRequest_requirements_met_does_not_mutate_argument_hash
    some_hash = {'Iron' => 'Man', 'Spider' => 'Boy'}
    tracker_request = RackUsageTracking::TrackerRequest.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_request.requirements_met?(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerRequest_responds_to_track_data
    tracker_request = RackUsageTracking::TrackerRequest.new

    responds_to_track_data = tracker_request.respond_to?(:track_data)

    assert_equal(true, responds_to_track_data)
  end

  def test_that_RackUsageTracking_TrackerRequest_track_data_takes_single_hash_as_argument
    some_hash = Hash.new
    tracker_request = RackUsageTracking::TrackerRequest.new

    tracked_data = tracker_request.track_data(some_hash)

    refute_nil(tracked_data)
  end

  def test_that_RackUsageTracking_TrackerRequest_track_data_does_not_mutate_argument_hash
    some_hash = {'Aqua' => 'Man', 'Super' => 'Woman'}
    tracker_request = RackUsageTracking::TrackerRequest.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_request.track_data(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerRequest_track_data_resets_count_to_zero_when_date_changes
    skip
    # use today to detect this
  end

# test_that_RackUsageTracking_TrackerRequest
# RackUsageTracking::TrackerRequest

=begin
  Tests to write:
  > #track_data
    - resets count to zero when date changed

  > #count
    - respond to?
    - starts at zero as int
    - returns correct integer count of days, i.e. increment by 1 for each update as int

  > #today
    - respond to?
    - starts at zero
    - returns correct integer count of days, i.e, increment by 1 for each update as int
    - when date the same, returns total requests made SAME DAY (UTC) as int
    - when date changed, resets count to zero AFTER update (UTC) as int

=end
end