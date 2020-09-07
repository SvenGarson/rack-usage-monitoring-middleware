require_relative '../test_prerequisites'
require_relative '../test_helpers'

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
    reset_counter = RackUsageAttributes::AttributeCounterDailyReset.new

    (1..150).each do |run|
      # first update_each increments zero to one
      count_after_incrementing = reset_counter.update_each

      assert_equal(run, count_after_incrementing)
      assert_instance_of(Integer, count_after_incrementing)
    end
  end

  def test_that_RackUsageAttributes_AttributeCounterDailyReset_responds_to_today
    assert_equal(true, RackUsageAttributes::AttributeCounterDailyReset.new.respond_to?(:today))
  end

  def test_that_RackUsageAttributes_AttributeCounterDailyReset_today_returns_correct_integer_count_before_first_update
    first_today = RackUsageAttributes::AttributeCounterDailyReset.new.today

    assert_equal(0, first_today)
    assert_instance_of(Integer, first_today)
  end

  def test_that_RackUsageAttributes_AttributeCounterDailyReset_today_resets_to_zero_when_date_changes
    base_date = Date.strptime('21/12/2020', '%d/%m/%Y')
    RackUsageUtils::OverrideableDate.set_today_date(base_date)

    reset_counter = RackUsageAttributes::AttributeCounterDailyReset.new

    assert_equal(0, reset_counter.today)
    reset_counter.update
    assert_equal(1, reset_counter.today)

    RackUsageUtils::OverrideableDate.set_today_date(base_date + 1)    
    reset_counter.update
    assert_equal(0, reset_counter.today)
    reset_counter.update
    assert_equal(1, reset_counter.today)
  end

  def test_that_RackUsageAttributes_AttributeCounterDailyReset_today_resets_to_zero_each_day_for_over_a_year
    today_date = Date.strptime('21/12/2020', '%d/%m/%Y')
    RackUsageUtils::OverrideableDate.set_today_date(today_date)

    reset_counter = RackUsageAttributes::AttributeCounterDailyReset.new

    400.times do |_|
      assert_equal(0, reset_counter.today)
      reset_counter.update
      assert_equal(1, reset_counter.today)
      
      # go to next day and reset
      today_date += 1
      RackUsageUtils::OverrideableDate.set_today_date(today_date)    
      reset_counter.update
    end
  end
end