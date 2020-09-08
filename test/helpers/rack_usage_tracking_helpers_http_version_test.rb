require_relative '../test_prerequisites'

class RackUsageTrackingHelpersHttpVersionTest < Minitest::Test
  def setup
    @http_version_0_9 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9')
    @http_version_1_0 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.0')
    @http_version_1_1 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.1')
    @http_version_2_0 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0')
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_accessible_when_middleware_required
    assert(defined?(RackUsageTrackingHelpers::HttpVersion))
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_new_takes_single_string_argument
    assert_instance_of(RackUsageTrackingHelpers::HttpVersion, http_version_0_9)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_responds_to_major
    assert_respond_to(http_version_0_9, :major)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_0_9_major
    major = http_version_0_9.major

    assert_instance_of(Integer, major)
    assert_equal(0, major)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_1_0_major
    major = http_version_1_0.major

    assert_instance_of(Integer, major)
    assert_equal(1, major)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_1_1_major
    major = http_version_1_1.major

    assert_instance_of(Integer, major)
    assert_equal(1, major)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_2_0_major
    major = http_version_2_0.major

    assert_instance_of(Integer, major)
    assert_equal(2, major)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_responds_to_minor
    assert_respond_to(http_version_0_9, :minor)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_0_9_minor
    minor = http_version_0_9.minor

    assert_instance_of(Integer, minor)
    assert_equal(9, minor)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_1_0_minor
    minor = http_version_1_0.minor

    assert_instance_of(Integer, minor)
    assert_equal(0, minor)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_1_1_minor
    minor = http_version_1_1.minor

    assert_instance_of(Integer, minor)
    assert_equal(1, minor)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_2_0_minor
    minor = http_version_2_0.minor

    assert_instance_of(Integer, minor)
    assert_equal(0, minor)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_spaceship_operator_returns_nil_when_objects_cannot_be_compared
    string_object = 'not an HttpVersion object'

    assert_nil(http_version_2_0 <=> string_object)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_spaceship_operator_returns_integer_when_objects_can_be_compared
    assert_instance_of(Integer, http_version_0_9 <=> http_version_2_0)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_spaceship_operator_returns_zero_when_objects_are_considered_identical
    comparison_of_identical_http_versions = http_version_2_0 <=> http_version_2_0

    assert_equal(0, comparison_of_identical_http_versions)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_spaceship_operator_returns_negative_1_when_left_object_is_considered_lower_than_right_object
    comparison_of_lower_to_higher_http_versions = http_version_1_0 <=> http_version_2_0

    assert_equal(-1, comparison_of_lower_to_higher_http_versions)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_spaceship_operator_returns_positive_1_when_left_object_is_considered_higher_than_right_object
    comparison_of_higher_to_lower_http_versions = http_version_2_0 <=> http_version_1_0

    assert_equal(1, comparison_of_higher_to_lower_http_versions)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_hash_returns_correct_unique_integer_based_on_major_and_minor_version
    hash_http_version_0_9 = http_version_0_9.hash
    hash_http_version_1_0 = http_version_1_0.hash
    hash_http_version_1_1 = http_version_1_1.hash
    hash_http_version_2_0 = http_version_2_0.hash


    assert_equal((0 * 10) + (9 * 1), hash_http_version_0_9)
    assert_equal((1 * 10) + (0 * 1), hash_http_version_1_0)
    assert_equal((1 * 10) + (1 * 1), hash_http_version_1_1)
    assert_equal((2 * 10) + (0 * 1), hash_http_version_2_0)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_eql_returns_false_when_separate_http_versions_mismatch
    mismatched_http_versions = http_version_1_0.eql?(http_version_2_0)

    assert_equal(false, mismatched_http_versions)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_eql_returns_true_when_separate_http_versions_match
    other_http_version_2_0 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0')
    matching_http_versions = http_version_2_0.eql?(other_http_version_2_0)

    # must test different objects because the Object#eql? method compares object IDs when not overriden
    refute_same(http_version_2_0, other_http_version_2_0, "Compared HttpVersion objects must be different objects in memory")

    # test whether different HttpVersion objects match in terms of major and minor version and not
    # their object IDs
    assert_equal(true, matching_http_versions, "Compared HttpVersion objects must be compared by their major and minor version")
  end

  private

  attr_reader(:http_version_0_9, :http_version_1_0, :http_version_1_1, :http_version_2_0)
end