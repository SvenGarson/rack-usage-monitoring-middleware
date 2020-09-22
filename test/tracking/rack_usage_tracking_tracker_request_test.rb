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

  def test_that_RackUsageTracking_TrackerRequest_track_data_does_not_mutate_argument_hash
    some_hash = {'Aqua' => 'Man', 'Super' => 'Woman'}
    tracker_request = RackUsageTracking::TrackerRequest.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_request.track_data(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerRequest_responds_to_count
    tracker_request = RackUsageTracking::TrackerRequest.new

    responds_to_count = tracker_request.respond_to?(:count)

    assert_equal(true, responds_to_count)
  end

  def test_that_RackUsageTracking_TrackerRequest_count_initialized_to_zero
    tracker_request = RackUsageTracking::TrackerRequest.new

    count = tracker_request.count

    assert_equal(0, count)
  end

  def test_that_RackUsageTracking_TrackerRequest_count_incremented_by_one_for_each_track_data_update
    some_hash = Hash.new
    tracker_request = RackUsageTracking::TrackerRequest.new

    0.upto(400) do |expected_count|
      actual_count = tracker_request.count
      tracker_request.track_data(some_hash)

      assert_equal(expected_count, actual_count)
    end
  end

  def test_that_RackUsageTracking_TrackerRequest_responds_to_today
    tracker_request = RackUsageTracking::TrackerRequest.new

    responds_to_today = tracker_request.respond_to?(:today)

    assert_equal(true, responds_to_today)
  end

  def test_that_RackUsageTracking_TrackerRequest_today_initialized_to_zero
    tracker_request = RackUsageTracking::TrackerRequest.new

    today = tracker_request.today

    assert_equal(0, today)
  end

  def test_that_RackUsageTracking_TrackerRequest_today_incremented_by_one_for_each_track_data_update_during_the_same_day
    # lock date used internally to today
    RackUsageUtils::OverrideableDate.set_today_date(Date.today)

    some_hash = Hash.new
    tracker_request = RackUsageTracking::TrackerRequest.new

    0.upto(400) do |expected_today|
      actual_today = tracker_request.today
      tracker_request.track_data(some_hash)

      assert_equal(expected_today, actual_today)
    end
  end

  def test_that_RackUsageTracking_TrackerRequest_today_resets_to_zero_when_date_changes
    base_date = Date.today
    some_hash = Hash.new
    tracker_request = RackUsageTracking::TrackerRequest.new

    # go through over a year of dates starting at today
    400.times do |day|
      # set date to use and lock the data for todays requests
      RackUsageUtils::OverrideableDate.set_today_date(base_date + day)

      # force update on tracker request to test whether reset to zero is triggered
      # but this update counts as request, so the zero is immediately incremented to one
      tracker_request.track_data(some_hash)

      requests_made_today = (rand * 100.0).to_i

      requests_made_today.times do |request_index|
        expected_today = request_index + 1
        actual_today = tracker_request.today

        tracker_request.track_data(some_hash)

        assert_equal(expected_today, actual_today)
      end
    end
  end
end