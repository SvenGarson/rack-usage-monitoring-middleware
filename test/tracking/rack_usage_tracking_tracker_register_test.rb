require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageTrackingTrackerRegisterTest < Minitest::Test
  def test_that_RackUsageTracking_TrackerRegister_accessible_when_middleware_required
    assert(defined?(RackUsageTracking::TrackerRegister))
  end

  def test_that_RackUsageTracking_TrackerRegister_responds_to_register
    tracker_register = RackUsageTracking::TrackerRegister.new

    assert_equal(true, tracker_register.respond_to?(:register))
  end

  def test_that_RackUsageTracking_TrackerRegister_register_takes_tracker_name_and_tracker_instance_as_argument
    tracker_register = RackUsageTracking::TrackerRegister.new
    tracker_instance = Helpers::DummyTracker.new(requirements_met: true)

    refute_nil(tracker_register.register(:requests, tracker_instance))
  end

  def test_that_RackUsageTracking_TrackerRegister_register_returns_tracker_name_argument
    tracker_register = RackUsageTracking::TrackerRegister.new    
    tracker_name = :requests
    tracker_instance = Helpers::DummyTracker.new(requirements_met: true)

    registered_name = tracker_register.register(tracker_name, tracker_instance)    

    assert_same(tracker_name, registered_name)
  end

  def test_that_RackUsageTracking_TrackerRegister_register_overrides_tracker_instance_to_the_most_recent_when_tracker_name_already_registered
    tracker_register = RackUsageTracking::TrackerRegister.new

    tracker_name = :alfa
    initial_tracker_instance = Helpers::DummyTracker.new(requirements_met: true)
    subsequent_tracker_instance = Helpers::DummyTracker.new(requirements_met: true)
    
    tracker_register.register(tracker_name, initial_tracker_instance)
    initial_tracker_registered = tracker_register.tracker_named(tracker_name)

    tracker_register.register(tracker_name, subsequent_tracker_instance)
    subsequent_tracker_registered = tracker_register.tracker_named(tracker_name)

    assert_same(initial_tracker_instance, initial_tracker_registered, "Initial tracker not registered")
    assert_same(subsequent_tracker_instance, subsequent_tracker_registered, "Subsequent tracker did not override previous tracker with same name")
  end

  def test_that_RackUsageTracking_TrackerRegister_responds_to_update_all
    tracker_register = RackUsageTracking::TrackerRegister.new

    assert_equal(true, tracker_register.respond_to?(:update_all))
  end

  def test_that_RackUsageTracking_TrackerRegister_update_all_takes_single_hash_as_argument
    tracker_register = RackUsageTracking::TrackerRegister.new
    hash = Hash.new

    all_updated = tracker_register.update_all(hash)

    refute_nil(all_updated)
  end

  def test_that_RackUsageTracking_TrackerRegister_update_all_returns_un_mutated_hash_argument
    tracker_register = RackUsageTracking::TrackerRegister.new
    hash = {'Iron' => 'Man', 'Spider' => 'Boy'}
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(hash)
    
    all_updated = tracker_register.update_all(hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(all_updated)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerRegister_update_all_updates_only_trackers_with_requirements_met
    some_hash = Hash.new
    tracker_register = RackUsageTracking::TrackerRegister.new

    tracker_requirements_met = Helpers::DummyTracker.new(requirements_met: true)
    tracker_requirements_not_met = Helpers::DummyTracker.new(requirements_met: false)
    tracker_register.register(:met, tracker_requirements_met)
    tracker_register.register(:not_met, tracker_requirements_not_met)

    tracker_register.update_all(some_hash)

    assert_equal(true, tracker_requirements_met.track_data_invoked?, "#track_data not invoked even though #requirements_met? returns true")
    assert_equal(false, tracker_requirements_not_met.track_data_invoked?, "#track_data invoked even though #requirements_met? returns false")
  end

  def test_that_RackUsageTracking_TrackerRegister_responds_to_has_tracker_named
    tracker_register = RackUsageTracking::TrackerRegister.new

    assert_equal(true, tracker_register.respond_to?(:has_tracker_named?))
  end

  def test_that_RackUsageTracking_TrackerRegister_has_tracker_named_takes_tracker_name_symbol_as_argument
    tracker_register = RackUsageTracking::TrackerRegister.new
    tracker_name = :foobar

    has_tracker_named = tracker_register.has_tracker_named?(tracker_name)

    refute_nil(has_tracker_named)
  end

  def test_that_RackUsageTracking_TrackerRegister_has_tracker_named_returns_false_when_tracker_name_not_registered
    tracker_register = RackUsageTracking::TrackerRegister.new

    has_tracker_named_velocity = tracker_register.has_tracker_named?(:velocity)

    assert_equal(false, has_tracker_named_velocity)
  end

  def test_that_RackUsageTracking_TrackerRegister_has_tracker_named_returns_true_when_tracker_registered
    tracker_register = RackUsageTracking::TrackerRegister.new
    tracker_name = :magnitude
    tracker_register.register(tracker_name, Helpers::DummyTracker.new(requirements_met: true))

    has_tracker_named_magnitude = tracker_register.has_tracker_named?(tracker_name)

    assert_equal(true, has_tracker_named_magnitude)
  end

  def test_that_RackUsageTracking_TrackerRegister_responds_to_tracker_named
    tracker_register = RackUsageTracking::TrackerRegister.new

    assert_equal(true, tracker_register.respond_to?(:tracker_named))
  end

  def test_that_RackUsageTracking_TrackerRegister_tracker_named_takes_tracker_name_symbol_as_argument
    tracker_register = RackUsageTracking::TrackerRegister.new

    tracker_named = tracker_register.tracker_named(:speed)

    assert_nil(tracker_named)
  end

  def test_that_RackUsageTracking_TrackerRegister_tracker_named_returns_nil_when_tracker_name_not_registered
    tracker_register = RackUsageTracking::TrackerRegister.new

    tracker_named = tracker_register.tracker_named(:direction)

    assert_nil(tracker_named)
  end

  def test_that_RackUsageTracking_TrackerRegister_tracker_named_returns_tracker_instance_when_tracker_registered
    tracker_register = RackUsageTracking::TrackerRegister.new
    tracker_name = :cipher
    tracker_instance = Helpers::DummyTracker.new(requirements_met: true)
    tracker_register.register(tracker_name, tracker_instance)

    tracker_named = tracker_register.tracker_named(tracker_name)

    assert_equal(tracker_instance, tracker_named)
  end
end