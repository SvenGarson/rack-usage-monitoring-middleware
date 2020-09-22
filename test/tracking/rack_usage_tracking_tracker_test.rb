require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageTrackingTrackerTest < Minitest::Test
  def test_that_RackUsageTracking_Tracker_accessible_when_middleware_required
    assert(defined?(RackUsageTracking::Tracker))
  end

  def test_that_RackUsageTracking_Tracker_responds_to_requirements_met
    assert_equal(true, RackUsageTracking::Tracker.new.respond_to?(:requirements_met?))
  end

  def test_that_RackUsageTracking_Tracker_requirements_met_takes_single_hash_argument
    tracker = RackUsageTracking::Tracker.new
    hash = Hash.new

    requirements_met = tracker.requirements_met?(hash)

    refute_nil(requirements_met)
  end

  def test_that_RackUsageTracking_Tracker_requirements_met_always_returns_false
    tracker = RackUsageTracking::Tracker.new
    hash = Hash.new

    requirements_met = tracker.requirements_met?(hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_Tracker_requirements_met_does_not_mutate_argument_hash
    tracker = RackUsageTracking::Tracker.new
    hash = {'foo' => 'bar', 'Iron' => 'Man'}
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(hash)

    tracker.requirements_met?(hash)    
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end
end