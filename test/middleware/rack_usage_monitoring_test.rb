require_relative '../test_prerequisites'

class RackUsageMonitoringTest < Minitest::Test
  def test_that_RackUsageMonitoring_accessible_when_middleware_required
    assert(defined?(RackUsageMonitoring))
  end

  def test_that_RackUsageMonitoring_responds_to_usage_data
    assert_respond_to(RackUsageMonitoring, :usage_data)
  end

  def test_that_RackUsageMonitoring_usage_data_returns_nil_when_middleware_not_called_before
    env = Hash.new

    assert_nil(RackUsageMonitoring.usage_data(env))
  end

  def test_that_RackUsageMonitoring_usage_data_returns_UsageDataProtected_when_middleware_called_before
    env = Hash.new
    middleware = RackUsageMonitoring::Middleware.new
    middleware.call(env)

    usage_data_protected = RackUsageMonitoring.usage_data(env)

    refute_nil(usage_data_protected)
    assert_instance_of(RackUsageMonitoring::UsageDataProtected, usage_data_protected)
  end
end