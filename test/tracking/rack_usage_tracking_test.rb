require_relative '../test_prerequisites'

class RackUsageTrackingTest < Minitest::Test
  def test_that_RackUsageTracking_accessible_when_middleware_required
    assert(defined?(RackUsageTracking))
  end
end