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

  def test_that_RackUsageMonitoring_Constants_is_frozen
    assert_equal(true, RackUsageMonitoring::Constants.frozen?)
  end
end