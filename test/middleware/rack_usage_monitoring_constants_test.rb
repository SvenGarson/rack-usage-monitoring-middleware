require_relative '../test_prerequisites'

class RackUsageMonitoringConstantsTest < Minitest::Test
  def test_that_RackUsageMonitoring_Constants_accessible_when_middleware_required
    assert(defined?(RackUsageMonitoring::Constants))
  end

  def test_that_RackUsageMonitoring_Constants_contains_KEY_USAGE_DATA_PROTECTED
    assert(defined?(RackUsageMonitoring::Constants::KEY_USAGE_DATA_PROTECTED))
  end

  def test_that_RackUsageMonitoring_Constants_KEY_USAGE_DATA_PROTECTED_is_a_symbol
    assert_instance_of(Symbol, RackUsageMonitoring::Constants::KEY_USAGE_DATA_PROTECTED)
  end

  def test_that_RackUsageMonitoring_Constants_KEY_USAGE_DATA_PROTECTED_has_the_correct_value
    assert_equal('rack_usage_monitoring.usage_data_protected'.to_sym,
                 RackUsageMonitoring::Constants::KEY_USAGE_DATA_PROTECTED)
  end

  def test_that_RackUsageMonitoring_Constants_contains_RACK_ENV_NONE
    assert(defined?(RackUsageMonitoring::Constants::RACK_ENV_NONE))
  end

  def test_that_RackUsageMonitoring_Constants_RACK_ENV_NONE_is_a_string
    assert_instance_of(String, RackUsageMonitoring::Constants::RACK_ENV_NONE)
  end

  def test_that_RackUsageMonitoring_Constants_RACK_ENV_NONE_has_the_correct_value
    assert_equal('none', RackUsageMonitoring::Constants::RACK_ENV_NONE)
  end

  def test_that_RackUsageMonitoring_Constants_contains_RACK_ENV_DEVELOPMENT
    assert(defined?(RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT))
  end

  def test_that_RackUsageMonitoring_Constants_RACK_ENV_DEVELOPMENT_is_a_string
    assert_instance_of(String, RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT)
  end

  def test_that_RackUsageMonitoring_Constants_RACK_ENV_DEVELOPMENT_has_the_correct_value
    assert_equal('development', RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT)
  end

  def test_that_RackUsageMonitoring_Constants_contains_RACK_ENV_DEPLOYMENT
    assert(defined?(RackUsageMonitoring::Constants::RACK_ENV_DEPLOYMENT))
  end

  def test_that_RackUsageMonitoring_Constants_RACK_ENV_DEPLOYMENT_is_a_string
    assert_instance_of(String, RackUsageMonitoring::Constants::RACK_ENV_DEPLOYMENT)
  end

  def test_that_RackUsageMonitoring_Constants_RACK_ENV_DEPLOYMENT_has_the_correct_value
    assert_equal('deployment', RackUsageMonitoring::Constants::RACK_ENV_DEPLOYMENT)
  end

  def test_that_RackUsageMonitoring_Constants_contains_KEY_RACK_ENV
    assert(defined?(RackUsageMonitoring::Constants::KEY_RACK_ENV))
  end

  def test_that_RackUsageMonitoring_Constants_KEY_RACK_ENV_is_a_string
    assert_instance_of(String, RackUsageMonitoring::Constants::KEY_RACK_ENV)
  end

  def test_that_RackUsageMonitoring_Constants_KEY_RACK_ENV_has_the_correct_value
    assert_equal('RACK_ENV', RackUsageMonitoring::Constants::KEY_RACK_ENV)
  end

  def test_that_RackUsageMonitoring_Constants_is_frozen
    assert_equal(true, RackUsageMonitoring::Constants.frozen?)
  end
end