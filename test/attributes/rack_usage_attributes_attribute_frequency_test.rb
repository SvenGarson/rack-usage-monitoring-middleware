require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageAttributesAttributeFrequencyTest < Minitest::Test
  def test_that_RackUsageAttributes_AttributeFrequency_accessible_when_middleware_required
    assert(defined?(RackUsageAttributes::AttributeFrequency))
  end

  def test_that_RackUsageAttributes_AttributeFrequency_is_subclass_of_Attribute
    assert_equal(true, RackUsageAttributes::AttributeFrequency < RackUsageAttributes::Attribute)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_mixes_in_UpdateableEach
    assert_equal(true,
                 Helpers.class_includes_modules(RackUsageAttributes::AttributeFrequency, RackUsageAttributes::UpdateableEach)
                )
  end

  def test_that_RackUsageAttributes_AttributeFrequency_update_works_without_any_arguments_and_returns_nil
    assert_nil(RackUsageAttributes::AttributeFrequency.new.update)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_update_can_take_single_argument_and_returns_original_argument
    passed_object = 'hello again'

    return_value = RackUsageAttributes::AttributeFrequency.new.update(passed_object)

    assert_same(passed_object, return_value)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_responds_to_update_each
    assert_equal(true, RackUsageAttributes::AttributeFrequency.new.respond_to?(:update_each))
  end

  def test_that_RackUsageAttributes_AttributeFrequency_update_each_returns_original_argument
    frequency = RackUsageAttributes::AttributeFrequency.new

    passed_object = 'what is my frequency'
    return_value = frequency.update_each(passed_object)

    assert_same(passed_object, return_value)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_responds_to_least_frequent
    assert_equal(true, RackUsageAttributes::AttributeFrequency.new.respond_to?(:least_frequent))
  end

  def test_that_RackUsageAttributes_AttributeFrequency_least_frequent_returns_empty_array_when_not_yet_updated
    frequency = RackUsageAttributes::AttributeFrequency.new

    least_frequent = frequency.least_frequent

    assert_instance_of(Array, least_frequent)
    assert_empty(least_frequent)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_least_frequent_returns_array_with_correct_objects_when_already_updated
    frequency = RackUsageAttributes::AttributeFrequency.new

    first_string = 'hello fella'
    second_string = 'I like ice cream'
    third_string = 'foobar'

    frequency.update(first_string)
    frequency.update(second_string)
    frequency.update(third_string)

    least_frequent = frequency.least_frequent

    assert_instance_of(Array, least_frequent)
    assert_includes(least_frequent, first_string)
    assert_includes(least_frequent, second_string)
    assert_includes(least_frequent, third_string)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_least_frequent_returns_array_with_correct_dupped_objects_when_already_updated
    frequency = RackUsageAttributes::AttributeFrequency.new

    first_string = 'hello fella'
    second_string = 'I like ice cream'
    third_string = 'foobar'

    frequency.update(first_string)
    frequency.update(second_string)
    frequency.update(third_string)

    least_frequent = frequency.least_frequent

    assert_instance_of(Array, least_frequent)

    # objects in the array returned by #least_frequent must not be the same reference as 
    # what was passed to #update
    least_frequent.each do |least_frequent_object|
      refute_same(least_frequent_object, first_string)
      refute_same(least_frequent_object, second_string)
      refute_same(least_frequent_object, third_string)
    end
  end
end

# AttributeFrequency
# test_that_RackUsageAttributes_AttributeFrequency
# RackUsageAttributes::AttributeFrequency.new

=begin

  # Tests to write

  #least_frequent
    - returns ARRAY with CORRECT LEAST FREQUENT DUPPED passed objects  WHEN UPDATED BEFORE
    - does not contain duplicates in terms of string
    - data can be passed as ARRAY and SINGLE
  #most_frequent
  - responds
    - returns EMPTY ARRAY if NOT UPDATED before
    - returns ARRAY with CORRECT MOST FREQUENT passed objects WHEN UPDATED BEFORE
    - returns ARRAY with CORRECT DUPPED MOST FREQUENT passed objects  WHEN UPDATED BEFORE
    - does not contain duplicated in terms of strings
    - data can be passed as ARRAY and SINGLE
  #all
    - responds
    - returns EMPTY ARRAY if NOT UPDATED before
    - returns ARRAY with ALL PASSED OBJECTS WHEN UPDATED BEFORE
    - returns ARRAY with ALL DUPPED PASSED OBJECTS
    - does not contain duplicated in terms of strings
    - data can be passed as ARRAY and SINGLE
  #update_each
    - update_each DOES add object to hash if not yet in the hash (returned array grows)
    - update_each does NOT add object to hash but increents the count (returned array does NOT grow)
    

=end
