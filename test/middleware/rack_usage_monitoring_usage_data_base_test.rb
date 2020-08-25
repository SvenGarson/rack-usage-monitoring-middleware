require_relative '../test_prerequisites'

class RackUsageMonitoringUsageDataBaseTest < Minitest::Test
  def test_that_RackUsageMonitoring_UsageDataBase_accessible_when_middleware_required
    assert(defined?(RackUsageMonitoring::UsageDataBase))
  end
end