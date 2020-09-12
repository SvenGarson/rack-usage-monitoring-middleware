require_relative '../test_prerequisites'

class RackUsageTrackingTrackerTest < Minitest::Test
  def test_that_RackUsageTracking_Tracker_accessible_when_middleware_required
    assert(defined?(RackUsageTracking::Tracker))
  end

  def test_that_RackUsageTracking_Tracker_responds_to_requirements_met
    assert_equal(true, RackUsageTracking::Tracker.new.respond_to?(:requirements_met?))
  end

  def test_that_RackUsageTracking_Tracker_requirements_met_takes_single_hash_argument
    tracker = RackUsageTracking::Tracker.new
    argument = Hash.new

    requirements_met = tracker.requirements_met?(argument)

    refute_nil(requirements_met)
  end

  def test_that_RackUsageTracking_Tracker_requirements_met_always_returns_false
    tracker = RackUsageTracking::Tracker.new
    argument = Hash.new

    requirements_met = tracker.requirements_met?(argument)

    assert_equal(false, requirements_met)
  end

=begin
  def test_that_RackUsageTracking_Tracker_requirements_met_does_not_mutate_argument

    1. pass a hash
    2. potentially mutate hash: in the following ways:
        - change key/value reference
        - change key/value value
        - add/remove entries
    3. get hash back that is not necessarily the same as the argument

    Now we want to test from the argument to the return value if:
      - Both are the same object.
        This means that a == b is true (size and key/value matched using #==)
      # we know a.equal(b) == true AND (a == b) == true
      - All correspongin K/V pairs have the exact same object ID

  end
=end

  # test_that_RackUsageTracking_Tracker
  # RackUsageTracking::Tracker

  def test_that_hashes_with_different_object_ids_are_considered_non_identical
    a = Hash.new
    b = Hash.new

    identical = hashes_identical(a, b)

    refute_same(a, b)
    assert_equal(false, identical)
  end

  def test_that_hashes_with_different_sizes_are_considered_non_identical
    a = {a: 65, b: 66}
    b = {a: 65, b: 66, c:67}

    identical = hashes_identical(a, b)

    assert_equal(false, a == b)
    assert_equal(false, a.size == b.size)
  end

  private

  def hashes_identical(a, b)
    # a and b ids must be the same object
    return false unless a.equal?(b)

    # At this point we know both references point to the same Hash which means
    # a and b have the same size
    # a == b based on #== comparison

    # We don't know wether keys and value objects in both hashes are the exact same
    # objects. Since these tests are about strings, checking for equal ids at
    # this level exclusively is what we want, i.e. determine whether the hash
    # has been tampered with, because, even if one string was replaced with the same
    # value string, the object id is different.
    data_a = a.to_a.flatten
    data_b = b.to_a.flatten

    key_value_references_identical = true

    data_a.each_index do |index|
      reference_a = data_a[index]
      reference_b = data_b[index]

      unless reference_a.equal?(reference_b)
        key_value_references_identical = false
        break
      end
    end

    key_value_references_identical
  end

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