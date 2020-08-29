require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageAttributesAttributeCounterTest < Minitest::Test
  def test_that_RackUsageAttributes_AttributeCounter_accessible_when_middleware_required
    assert(defined?(RackUsageAttributes::AttributeCounter))
  end

  def test_that_RackUsageAttributes_AttributeCounter_is_subclass_of_Attribute
    assert_equal(true, RackUsageAttributes::AttributeCounter < RackUsageAttributes::Attribute)
  end

  def test_that_RackUsageAttributes_AttributeCounter_mixes_in_UpdateableEach
    assert_equal(true,
                 Helpers.class_includes_modules(RackUsageAttributes::AttributeCounter, RackUsageAttributes::UpdateableEach)
                )
  end

  def test_that_RackUsageAttributes_AttributeCounter_update_works_without_any_arguments_and_returns_nil
    assert_nil(RackUsageAttributes::AttributeCounter.new.update)
  end

  def test_that_RackUsageAttributes_AttributeCounter_update_can_take_single_argument_and_returns_argument
    passed_object = 'hello'
    return_value = RackUsageAttributes::AttributeCounter.new.update(passed_object)
    assert_same(passed_object, return_value)
  end

  def test_that_RackUsageAttributes_AttributeCounter_responds_to_update_each
    assert_equal(true, RackUsageAttributes::AttributeCounter.new.respond_to?(:update_each))
  end

  def test_that_RackUsageAttributes_AttributeCounter_update_each_returns_correct_integer_count_after_incrementing
    counter = RackUsageAttributes::AttributeCounter.new

    (1..150).each do |run|
      # first update_each increments zero to one
      count_after_incrementing = counter.update_each

      assert_equal(run, count_after_incrementing)
      assert_instance_of(Integer, count_after_incrementing)
    end
  end

  def test_that_RackUsageAttributes_AttributeCounter_responds_to_count
    assert_equal(true, RackUsageAttributes::AttributeCounter.new.respond_to?(:count))
  end

  def test_that_RackUsageAttributes_AttributeCounter_count_returns_correct_integer_count_before_first_update
    first_count = RackUsageAttributes::AttributeCounter.new.count

    assert_equal(0, first_count)
    assert_instance_of(Integer, first_count)
  end

  def test_that_RackUsageAttributes_AttributeCounter_count_returns_correct_integer_count_after_first_update
    counter = RackUsageAttributes::AttributeCounter.new

    (1..150).each do |run|
      counter.update
      count = counter.count

      assert_equal(run, count)
      assert_instance_of(Integer, count)
    end
  end
end