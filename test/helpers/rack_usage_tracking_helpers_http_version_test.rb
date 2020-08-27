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

  private

  attr_reader(:http_version_0_9, :http_version_1_0, :http_version_1_1, :http_version_2_0)
end