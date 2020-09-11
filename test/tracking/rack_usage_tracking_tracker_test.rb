require_relative '../test_prerequisites'

class RackUsageTrackingTrackerTest < Minitest::Test
  def test_that_RackUsageTracking_Tracker_accessible_when_middleware_required
    assert(defined?(RackUsageTracking::Tracker))
  end

  def test_that_RackUsageTracking_Tracker_responds_to_requirements_met
    assert_equal(true, RackUsageTracking::Tracker.new.respond_to?(:requirements_met?))
  end

  # RackUsageTracking::Tracker

=begin
  Tests for Tracker

  #req_met?(env)
    - responds to
    - takes single hash argument
    - always returns false
    - does not mutate env
  #track(env)
    - responds to
    - takes single hash argument
    - returns env
    - does not mutate env
=end
end