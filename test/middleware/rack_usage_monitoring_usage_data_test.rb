require_relative '../test_prerequisites'

class RackUsageMonitoringUsageDataTest < Minitest::Test
  def test_that_RackUsageMonitoring_UsageData_accessible_when_middleware_required
    assert(defined?(RackUsageMonitoring::UsageData))
  end

  def test_that_RackUsageMonitoring_UsageData_is_subclass_of_UsageDataBase
    assert_equal(true, RackUsageMonitoring::UsageData < RackUsageMonitoring::UsageDataBase)
  end

  def test_that_RackUsageMonitoring_UsageData_responds_to_update
    assert_respond_to(RackUsageMonitoring::UsageData.new, :update)
  end

  def test_that_RackUsageMonitoring_UsageData_update_returns_unmodified_env_hash
    env = Hash.new

    return_value = RackUsageMonitoring::UsageData.new.update(env)

    assert_equal(env, return_value)
    assert_same(env, return_value)
  end
end