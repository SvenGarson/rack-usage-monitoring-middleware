require_relative '../test_prerequisites'
require_relative '../test_helpers'

class TestHelpersTest < Minitest::Test
  def test_that_HashDataPoints_double_equals_returns_false_when_hash_object_ids_differ
    a = Hash.new
    b = Hash.new

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(false, hashes_identical)
  end

  def test_that_HashDataPoints_double_equals_returns_true_when_hash_object_ids_identical
    a = Hash.new
    b = a

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(true, hashes_identical)
  end

  def test_that_HashDataPoints_double_equals_returns_false_when_hash_sizes_differ
    a = {a: 65}
    b = {a: 65, b: 66}

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(false, hashes_identical)
  end

  def test_that_HashDataPoints_double_equals_returns_false_when_hash_keys_values_differ
    a = {'foo' => 'bar'}
    b = {'zoo' => 'bar'}

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(false, hashes_identical)
  end

  def test_that_HashDataPoints_double_equals_returns_false_when_hash_values_values_differ
    a = {'foo' => 'bar'}
    b = {'foo' => 'far'}

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(false, hashes_identical)
  end

  def test_that_HashDataPoints_double_equals_returns_false_when_hash_keys_object_ids_differ
    a = {'name' => 'Thor'}
    b = {'name' => 'Thor'}

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(false, hashes_identical)
  end

  def test_that_HashDataPoints_double_equals_returns_false_when_hash_values_object_ids_differ
    a = {'name' => 'Thor'}
    b = {'name' => 'Thor'}

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(false, hashes_identical)
  end

  def test_that_DummyTracker_requirements_met_returns_expected_boolean_passed_to_new
    some_hash = Hash.new
    tracker_requirements_met     = Helpers::DummyTracker.new(requirements_met: true)
    tracker_requirements_not_met = Helpers::DummyTracker.new(requirements_met: false)

    requirements_met = tracker_requirements_met.requirements_met?(some_hash)
    requirements_not_met = tracker_requirements_not_met.requirements_met?(some_hash)

    assert_equal(true, requirements_met)
    assert_equal(false, requirements_not_met)
  end

  def test_that_DummyTracker_track_data_invoked_returns_false_when_track_data_not_yet_invoked
    tracker_requirements_not_met = Helpers::DummyTracker.new(requirements_met: false)

    track_data_invoked = tracker_requirements_not_met.track_data_invoked?

    assert_equal(false, track_data_invoked)
  end

  def test_that_DummyTracker_track_data_invoked_returns_true_when_track_data_invoked_before
    some_hash = Hash.new
    tracker_requirements_met = Helpers::DummyTracker.new(requirements_met: true)
    tracker_requirements_met.track_data(some_hash)

    track_data_invoked = tracker_requirements_met.track_data_invoked?

    assert_equal(true, track_data_invoked)
  end
end