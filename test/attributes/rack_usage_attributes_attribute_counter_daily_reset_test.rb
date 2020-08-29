require_relative '../test_prerequisites'
require_relative '../test_helpers'
require 'date'

class RackUsageAttributesAttributeCounterDailyResetTest < Minitest::Test
  def test_that_RackUsageAttributes_AttributeCounterDailyReset_accessible_when_middleware_required
    assert(defined?(RackUsageAttributes::AttributeCounterDailyReset))
  end

  def test_that_RackUsageAttributes_AttributeCounterDailyReset_is_subclass_of_Attribute
    assert_equal(true, RackUsageAttributes::AttributeCounterDailyReset < RackUsageAttributes::Attribute)
  end

  def test_that_RackUsageAttributes_AttributeCounterDailyReset_mixes_in_UpdateableEach
    assert_equal(true,
                 Helpers.class_includes_modules(RackUsageAttributes::AttributeCounterDailyReset, RackUsageAttributes::UpdateableEach)
                )
  end

  def test_that_RackUsageAttributes_AttributeCounterDailyReset_update_works_without_any_arguments_and_returns_nil
    assert_nil(RackUsageAttributes::AttributeCounterDailyReset.new.update)
  end

  def test_that_RackUsageAttributes_AttributeCounterDailyReset_update_can_take_single_argument_and_returns_argument
    passed_object = 'hello'
    return_value = RackUsageAttributes::AttributeCounterDailyReset.new.update(passed_object)
    assert_same(passed_object, return_value)
  end

  def test_that_RackUsageAttributes_AttributeCounterDailyReset_responds_to_update_each
    assert_equal(true, RackUsageAttributes::AttributeCounterDailyReset.new.respond_to?(:update_each))
  end

  def test_that_RackUsageAttributes_AttributeCounterDailyReset_update_each_returns_correct_integer_count_after_incrementing_the_same_day
    skip
    reset_counter = RackUsageAttributes::AttributeCounterDailyReset.new(Date.today)

    (1..150).each do |run|
      # first update_each increments zero to one
      count_after_incrementing = reset_counter.update_each

      assert_equal(run, count_after_incrementing)
      assert_instance_of(Integer, count_after_incrementing)
    end
  end

  def test_that_RackUsageAttributes_AttributeCounterDailyReset_responds_to_today
    skip
    assert_equal(true, RackUsageAttributes::AttributeCounterDailyReset.new.respond_to?(:today))
  end

  def test_that_RackUsageAttributes_AttributeCounterDailyReset_today_returns_correct_integer_count_before_first_update
    skip
    first_today = RackUsageAttributes::AttributeCounterDailyReset.new.today

    assert_equal(0, first_today)
    assert_instance_of(Integer, first_today)
  end

  def test_that_RackUsageAttributes_AttributeCounterDailyReset_today_returns_correct_integer_count_after_first_update
    skip
    reset_counter = RackUsageAttributes::AttributeCounterDailyReset.new(today)

    (1..150).each do |run|
      reset_counter.update
      count_today = reset_counter.today

      assert_equal(run, count_today)
      assert_instance_of(Integer, count_today)
    end
  end

=begin
  - new reset_counter created -> saved time time (can be overriden)
  - when updated:
    - now = time now (can be overriden)
    - if now is different day from when initiallized:
        - reset count to zero
    - increment count by 1
=end
end