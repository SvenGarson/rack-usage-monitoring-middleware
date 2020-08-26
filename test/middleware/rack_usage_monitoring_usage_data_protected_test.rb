require_relative '../test_prerequisites'

class RackUsageMonitoringUsageDataProtectedTest < Minitest::Test
  def setup
    @usage_data_protected = RackUsageMonitoring::UsageDataProtected.new
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_accessible_when_middleware_required
    assert(defined?(RackUsageMonitoring::UsageDataProtected))
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_is_subclass_of_UsageDataBase
    assert_equal(true, RackUsageMonitoring::UsageDataProtected < RackUsageMonitoring::UsageDataBase)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_responds_to_category_requests
    assert_respond_to(usage_data_protected, :requests)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_requests_returns_TrackerRequest
    assert_instance_of(RackUsageTracking::TrackerRequest, usage_data_protected.requests)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_responds_to_category_http_methods
    assert_respond_to(usage_data_protected, :http_methods)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_http_methods_returns_TrackerHttpMethod
    assert_instance_of(RackUsageTracking::TrackerHttpMethod, usage_data_protected.http_methods)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_responds_to_category_accepted_languages
    assert_respond_to(usage_data_protected, :accepted_languages)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_accepted_languages_returns_TrackerAcceptedLanguage
    assert_instance_of(RackUsageTracking::TrackerAcceptedLanguage, usage_data_protected.accepted_languages)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_responds_to_category_accepted_encodings
    assert_respond_to(usage_data_protected, :accepted_encodings)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_accepted_encodings_returns_TrackerAcceptedEncoding
    assert_instance_of(RackUsageTracking::TrackerAcceptedEncoding, usage_data_protected.accepted_encodings)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_responds_to_category_paths
    assert_respond_to(usage_data_protected, :paths)
  end
  
  def test_that_RackUsageMonitoring_UsageDataProtected_paths_returns_TrackerPath
    assert_instance_of(RackUsageTracking::TrackerPath, usage_data_protected.paths)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_responds_to_category_query_strings
    assert_respond_to(usage_data_protected, :query_strings)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_query_strings_returns_TrackerQueryString
    assert_instance_of(RackUsageTracking::TrackerQueryString, usage_data_protected.query_strings)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_responds_to_category_routes
    assert_respond_to(usage_data_protected, :routes)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_routes_returns_TrackerRoute
    assert_instance_of(RackUsageTracking::TrackerRoute, usage_data_protected.routes)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_responds_to_category_http_versions
    assert_respond_to(usage_data_protected, :http_versions)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_http_versions_returns_TrackerHttpVersion
    assert_instance_of(RackUsageTracking::TrackerHttpVersion, usage_data_protected.http_versions)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_responds_to_category_parameters
    assert_respond_to(usage_data_protected, :parameters)
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_parameters_returns_TrackerQueryParameter
    assert_instance_of(RackUsageTracking::TrackerQueryParameter, usage_data_protected.parameters)
  end

  private

  attr_reader(:usage_data_protected)
end