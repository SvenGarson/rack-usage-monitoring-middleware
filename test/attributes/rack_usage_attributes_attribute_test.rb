require_relative '../test_prerequisites'

class RackUsageAttributesAttributeTest < Minitest::Test
  def test_that_RackUsageAttributes_Attribute_accessible_when_middleware_required
    assert(defined?(RackUsageAttributes::Attribute))
  end

  def test_that_RackUsageAttributes_Attribute_responds_to_update
    assert_equal(true, RackUsageAttributes::Attribute.new.respond_to?(:update))
  end
end