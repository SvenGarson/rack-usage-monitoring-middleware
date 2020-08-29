require_relative '../test_prerequisites'

class RackUsageAttributesUpdateableEachTest < Minitest::Test
  def setup
    @updateable_object = Object.new.extend(RackUsageAttributes::UpdateableEach)
  end

  def test_that_RackUsageAttributes_UpdateableEach_accessible_when_middleware_required
    assert(defined?(RackUsageAttributes::UpdateableEach))
  end

  def test_that_RackUsageAttributes_UpdateableEach_responds_to_update_each
    assert_equal(true, @updateable_object.respond_to?(:update_each))
  end

  def test_that_RackUsageAttributes_UpdateableEach_works_without_any_arguments
    assert_nil(@updateable_object.update_each)
  end

  def test_that_RackUsageAttributes_UpdateableEach_can_take_single_optional_argument
    assert_nil(@updateable_object.update_each(12345))
  end
end