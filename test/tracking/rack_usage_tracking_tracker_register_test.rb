require_relative '../test_prerequisites'

class RackUsageTrackingTrackerRegisterTest < Minitest::Test
  def test_that_RackUsageTracking_TrackerRegister_accessible_when_middleware_required
    assert(defined?(RackUsageTracking::TrackerRegister))
  end

  def test_that_RackUsageTracking_TrackerRegister_responds_to_register
    tracker_register = RackUsageTracking::TrackerRegister.new

    assert_equal(true, tracker_register.respond_to?(:register))
  end

  def test_that_RackUsageTracking_TrackerRegister_register_takes_tracker_name_and_tracker_instance_as_argument
    skip
    tracker_register = RackUsageTracking::TrackerRegister.new

    # use dummy object with Trackermethods and behaviour for these unit tests!
    refute_nil(tracker_register.register(:requests, Object.new))
  end

# tracker_register = RackUsageTracking::TrackerRegister.new
# test_that_RackUsageTracking_TrackerRegister
# TrackerRegister

=begin
  
  TrackerRegister stuff to test:
  - namespace TrackeResgister
  > #register
    - takes tracker_name(symbol) and specific tracker instance as argument
    - adds the tracker instance to the register and associated it with the tracker name
    - registering the same name twice overrides the previous tracker instance with that same name
    - returns tracker_name symbol

  > #update_all
    - respond_to?
    - takes env hash as argument
    - returns env hash unmutated
    - updates registered tracker instances through #track_data that have their requirements met
      Maybe check this using a dummy object that has the appropriate methods?
      Maybe check invocation when req NOT met and vice-versa? YES!

  > #has_tracker_named?
    - respond_to?
    - takes single tracker name as symbol
    - returns true if registered, false if not

  > #tracker_named
    - respond_to?
    - takes single tracker name as symbol
    - returns the tracker object if it is registered, nil otherwise

=end
end