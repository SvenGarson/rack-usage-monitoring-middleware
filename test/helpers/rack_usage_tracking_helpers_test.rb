require_relative '../test_prerequisites'

class RackUsageTrackingHelpersTest < Minitest::Test
  def test_that_RackUsageTrackingHelpers_accessible_when_middleware_required
    assert(defined?(RackUsageTrackingHelpers))
  end
end