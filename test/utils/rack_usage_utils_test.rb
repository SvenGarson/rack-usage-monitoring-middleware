require_relative '../test_prerequisites'

class RackUsageUtilsTest < Minitest::Test
  def test_that_RackUsageUtils_accessible_when_middleware_required
    assert(defined?(RackUsageUtils))
  end
end