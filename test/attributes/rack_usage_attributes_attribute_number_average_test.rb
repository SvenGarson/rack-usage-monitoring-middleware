require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageAttributesAttributeNumberAverageTest < Minitest::Test
  def test_that_RackUsageAttributes_AttributeNumberAverage_accessible_when_middleware_required
    assert(defined?(RackUsageAttributes::AttributeNumberAverage))
  end

  def test_that_RackUsageAttributes_AttributeNumberAverage_is_subclass_of_Attribute
    assert_equal(true, RackUsageAttributes::AttributeNumberAverage < RackUsageAttributes::Attribute)
  end

  def test_that_RackUsageAttributes_AttributeNumberAverage_mixes_in_UpdateableEach
    assert_equal(true,
                 Helpers.class_includes_modules(RackUsageAttributes::AttributeNumberAverage, RackUsageAttributes::UpdateableEach)
                )
  end

  def test_that_RackUsageAttributes_AttributeNumberAverage_update_works_without_any_arguments_and_returns_nil
    assert_nil(RackUsageAttributes::AttributeNumberAverage.new.update)
  end

  def test_that_RackUsageAttributes_AttributeNumberAverage_update_can_take_single_argument_and_returns_original_argument
    passed_object = 'hello again'

    return_value = RackUsageAttributes::AttributeNumberAverage.new.update(passed_object)

    assert_same(passed_object, return_value)
  end

  def test_that_RackUsageAttributes_AttributeNumberAverage_responds_to_update_each
    assert_equal(true, RackUsageAttributes::AttributeNumberAverage.new.respond_to?(:update_each))
  end

  def test_that_RackUsageAttributes_AttributeNumberAverage_update_each_returns_float
    number_average = RackUsageAttributes::AttributeNumberAverage.new

    running_sum = number_average.update_each(2.5)

    assert_instance_of(Float, running_sum)
  end

  def test_that_RackUsageAttributes_AttributeNumberAverage_update_each_returns_running_sum_as_float
    number_average = RackUsageAttributes::AttributeNumberAverage.new

    numbers_to_average = [0, 0.0, 2.5, 6.5, 999, 999.0, 88.982, 1548.22225, 1]

    expected_running_sum = 0.0
    running_sum = nil

    numbers_to_average.each do |number|
      # Integers must be cast to Float before being accumulated
      expected_running_sum += number.to_f
      running_sum = number_average.update_each(number)
    end

    assert_instance_of(Float, running_sum)
    assert_equal(expected_running_sum, running_sum)
  end

  def test_that_RackUsageAttributes_AttributeNumberAverage_responds_to_average
    assert_equal(true, RackUsageAttributes::AttributeNumberAverage.new.respond_to?(:average))
  end

  def test_that_RackUsageAttributes_AttributeNumberAverage_average_returns_zero_as_float_and_handles_division_by_zero_when_not_yet_updated
    number_average = RackUsageAttributes::AttributeNumberAverage.new

    average = number_average.average

    assert_instance_of(Float, average)
    assert_equal(0.0, average)
  end

  def test_that_RackUsageAttributes_AttributeNumberAverage_average_returns_zero_as_float_when_updated_with_zeros_before
    number_average = RackUsageAttributes::AttributeNumberAverage.new

    10.times { |_| number_average.update(0.0) }

    average = number_average.average

    assert_instance_of(Float, average)
    assert_equal(0.0, average)
  end

  def test_that_RackUsageAttributes_AttributeNumberAverage_correct_average_when_updated_with_floats_only
    float_numbers_to_average = [1.1, 2.23, 3.345, 4.5678, 5.12345, 6.9999999]
    expected_running_sum = 0.0
    expected_running_count = 0

    float_numbers_to_average.each do |number|
      expected_running_sum += number.to_f
      expected_running_count += 1
    end

    # generate expected data as it is documented
    expected_average = expected_running_sum / expected_running_count.to_f

    # attributes can be updated with single objects or an array
    number_average_for_single_arguments = RackUsageAttributes::AttributeNumberAverage.new
    float_numbers_to_average.each { |number| number_average_for_single_arguments.update(number) }
    average_for_single_arguments = number_average_for_single_arguments.average

    number_average_for_array_argument = RackUsageAttributes::AttributeNumberAverage.new
    number_average_for_array_argument.update(float_numbers_to_average)
    average_for_array_argument = number_average_for_array_argument.average

    assert_equal(expected_average, average_for_single_arguments)
    assert_equal(expected_average, average_for_array_argument)
  end

  def test_that_RackUsageAttributes_AttributeNumberAverage_correct_average_when_updated_with_integers_only
    integer_numbers_to_average = [1, 50, 229, 5841, 55968, 169999, 175663]
    expected_running_sum = 0.0
    expected_running_count = 0

    integer_numbers_to_average.each do |number|
      expected_running_sum += number.to_f
      expected_running_count += 1
    end

    # generate expected data as it is documented
    expected_average = expected_running_sum / expected_running_count.to_f

    # attributes can be updated with single objects or an array
    number_average_for_single_arguments = RackUsageAttributes::AttributeNumberAverage.new
    integer_numbers_to_average.each { |number| number_average_for_single_arguments.update(number) }
    average_for_single_arguments = number_average_for_single_arguments.average

    number_average_for_array_argument = RackUsageAttributes::AttributeNumberAverage.new
    number_average_for_array_argument.update(integer_numbers_to_average)
    average_for_array_argument = number_average_for_array_argument.average

    assert_equal(expected_average, average_for_single_arguments)
    assert_equal(expected_average, average_for_array_argument)
  end

=begin
  #average
    - check expected average for mixed int and float numbers
=end

  # test_that_RackUsageAttributes_AttributeNumberAverage
  # AttributeNumberAverage
end