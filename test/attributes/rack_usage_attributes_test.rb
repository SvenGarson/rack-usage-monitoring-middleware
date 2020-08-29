require_relative '../test_prerequisites'

class RackUsageAttributesTest < Minitest::Test
  def test_that_RackUsageAttributes_accessible_when_middleware_required
    assert(defined?(RackUsageAttributes))
  end
end