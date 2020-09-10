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

  def test_that_RackUsageAttributes_AttributeFrequency_least_frequent_returns_array_with_expected_dupped_objects_when_already_updated
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

  def test_that_RackUsageAttributes_AttributeFrequency_least_frequent_returns_array_without_duplicates
    frequency = RackUsageAttributes::AttributeFrequency.new

    string_a = 'I am Super Man'
    string_b = 'I am Iron Man'

    frequency.update(string_a)
    frequency.update(string_a)

    frequency.update(string_b)
    frequency.update(string_b)

    least_frequent = frequency.least_frequent

    count_string_a = least_frequent.count(string_a)
    count_string_b = least_frequent.count(string_b)
    count_total = least_frequent.size

    assert_equal(1, count_string_a)
    assert_equal(1, count_string_b)
    assert_equal(2, count_total)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_can_be_updated_with_single_or_array_argument_for_identical_least_frequent_result
    frequency_single_arguments = RackUsageAttributes::AttributeFrequency.new
    frequency_array_argument = RackUsageAttributes::AttributeFrequency.new

    strings_to_determine_frequency_for = (%w(Pet key=value MyName1970 en;q=0.7) * 3)

    # update frequency with single arguments
    strings_to_determine_frequency_for.each do |string|
      frequency_single_arguments.update(string)
    end

    # update frequency with array argument
    frequency_array_argument.update(strings_to_determine_frequency_for)

    least_frequent_single_arguments = frequency_single_arguments.least_frequent
    least_frequent_array_argument = frequency_array_argument.least_frequent

    assert_equal(least_frequent_single_arguments, least_frequent_array_argument)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_least_frequent_returns_array_of_expected_objects_based_on_their_frequency
    frequency = RackUsageAttributes::AttributeFrequency.new

    string_a = 'Fastest'
    string_b = 'Widest'
    string_c = 'Darkest'
    string_d = 'Coolest'
    string_e = 'Tallest'

    3.times { |_| frequency.update(string_a) } # lowest frequency of 3
    3.times { |_| frequency.update(string_d) } # lowest frequency of 3
    3.times { |_| frequency.update(string_b) } # lowest frequency of 3
    7.times { |_| frequency.update(string_c) }
    9.times { |_| frequency.update(string_e) }

    least_frequent = frequency.least_frequent

    assert_includes(least_frequent, string_a)
    assert_includes(least_frequent, string_d)
    assert_includes(least_frequent, string_b)

    refute_includes(least_frequent, string_c)
    refute_includes(least_frequent, string_e)

    assert_equal(3, least_frequent.size)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_responds_to_most_frequent
    assert_equal(true, RackUsageAttributes::AttributeFrequency.new.respond_to?(:most_frequent))
  end

  def test_that_RackUsageAttributes_AttributeFrequency_most_frequent_returns_empty_array_when_not_yet_updated
    frequency = RackUsageAttributes::AttributeFrequency.new

    most_frequent = frequency.most_frequent

    assert_instance_of(Array, most_frequent)
    assert_empty(most_frequent)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_most_frequent_returns_array_with_expected_dupped_objects_when_already_updated
    frequency = RackUsageAttributes::AttributeFrequency.new

    first_string = 'hello fella'
    second_string = 'I like ice cream'
    third_string = 'foobar'

    frequency.update(first_string)
    frequency.update(second_string)
    frequency.update(third_string)

    most_frequent = frequency.most_frequent

    assert_instance_of(Array, most_frequent)

    # objects in the array returned by #most_frequent must not be the same reference as 
    # what was passed to #update
    most_frequent.each do |most_frequent_object|
      refute_same(most_frequent_object, first_string)
      refute_same(most_frequent_object, second_string)
      refute_same(most_frequent_object, third_string)
    end
  end

  def test_that_RackUsageAttributes_AttributeFrequency_most_frequent_returns_array_without_duplicates
    frequency = RackUsageAttributes::AttributeFrequency.new

    string_a = 'I am Super Man'
    string_b = 'I am Iron Man'

    frequency.update(string_a)
    frequency.update(string_a)

    frequency.update(string_b)
    frequency.update(string_b)

    most_frequent = frequency.most_frequent

    count_string_a = most_frequent.count(string_a)
    count_string_b = most_frequent.count(string_b)
    count_total = most_frequent.size

    assert_equal(1, count_string_a)
    assert_equal(1, count_string_b)
    assert_equal(2, count_total)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_can_be_updated_with_single_or_array_argument_for_identical_most_frequent_result
    frequency_single_arguments = RackUsageAttributes::AttributeFrequency.new
    frequency_array_argument = RackUsageAttributes::AttributeFrequency.new

    strings_to_determine_frequency_for = (%w(Pet key=value MyName1970 en;q=0.7) * 3)

    # update frequency with single arguments
    strings_to_determine_frequency_for.each do |string|
      frequency_single_arguments.update(string)
    end

    # update frequency with array argument
    frequency_array_argument.update(strings_to_determine_frequency_for)

    most_frequent_single_arguments = frequency_single_arguments.most_frequent
    most_frequent_array_argument = frequency_array_argument.most_frequent

    assert_equal(most_frequent_single_arguments, most_frequent_array_argument)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_most_frequent_returns_array_of_expected_objects_based_on_their_frequency
    frequency = RackUsageAttributes::AttributeFrequency.new

    string_a = 'Fastest'
    string_b = 'Widest'
    string_c = 'Darkest'
    string_d = 'Coolest'
    string_e = 'Tallest'

    9.times { |_| frequency.update(string_a) } # highest frequency of 9
    9.times { |_| frequency.update(string_d) } # highest frequency of 9
    9.times { |_| frequency.update(string_b) } # highest frequency of 9
    7.times { |_| frequency.update(string_c) }
    3.times { |_| frequency.update(string_e) }

    most_frequent = frequency.most_frequent

    assert_includes(most_frequent, string_a)
    assert_includes(most_frequent, string_d)
    assert_includes(most_frequent, string_b)

    refute_includes(most_frequent, string_c)
    refute_includes(most_frequent, string_e)

    assert_equal(3, most_frequent.size)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_responds_to_all
    assert_equal(true, RackUsageAttributes::AttributeFrequency.new.respond_to?(:all))
  end

  def test_that_RackUsageAttributes_AttributeFrequency_all_returns_empty_array_when_not_yet_updated
    frequency = RackUsageAttributes::AttributeFrequency.new

    all = frequency.all

    assert_instance_of(Array, all)
    assert_empty(all)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_all_returns_array_with_expected_dupped_objects_when_already_updated
    frequency = RackUsageAttributes::AttributeFrequency.new

    first_string = 'hello fella'
    second_string = 'I like ice cream'
    third_string = 'foobar'

    frequency.update(first_string)
    frequency.update(second_string)
    frequency.update(third_string)

    all = frequency.all
    count_all = all.size

    assert_instance_of(Array, all)
    assert_equal(3, count_all)

    # objects in the array returned by #all must not be the same reference as 
    # what was passed to #update
    all.each do |all_object|
      refute_same(all_object, first_string)
      refute_same(all_object, second_string)
      refute_same(all_object, third_string)
    end
  end

  def test_that_RackUsageAttributes_AttributeFrequency_all_returns_array_without_duplicates
    frequency = RackUsageAttributes::AttributeFrequency.new

    string_a = 'I am Super Man'
    string_b = 'I am Iron Man'

    frequency.update(string_a)
    frequency.update(string_a)

    frequency.update(string_b)
    frequency.update(string_b)
    frequency.update(string_b)

    all = frequency.all

    count_string_a = all.count(string_a)
    count_string_b = all.count(string_b)
    count_all = all.size

    assert_equal(1, count_string_a)
    assert_equal(1, count_string_b)
    assert_equal(2, count_all)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_can_be_updated_with_single_or_array_argument_for_identical_all_result
    frequency_single_arguments = RackUsageAttributes::AttributeFrequency.new
    frequency_array_argument = RackUsageAttributes::AttributeFrequency.new

    strings_to_determine_frequency_for = (%w(Pet key=value MyName1970 en;q=0.7) * 3)

    # update frequency with single arguments
    strings_to_determine_frequency_for.each do |string|
      frequency_single_arguments.update(string)
    end

    # update frequency with array argument
    frequency_array_argument.update(strings_to_determine_frequency_for)

    all_single_arguments = frequency_single_arguments.all
    all_array_argument = frequency_array_argument.all

    assert_equal(all_single_arguments, all_array_argument)
  end

  def test_that_RackUsageAttributes_AttributeFrequency_all_returns_array_of_all_objects
    frequency = RackUsageAttributes::AttributeFrequency.new

    string_a = 'Fastest'
    string_b = 'Widest'
    string_c = 'Darkest'
    string_d = 'Coolest'
    string_e = 'Tallest'

    2.times { |_| frequency.update(string_a) }
    3.times { |_| frequency.update(string_b) }
    4.times { |_| frequency.update(string_c) }
    5.times { |_| frequency.update(string_d) }
    6.times { |_| frequency.update(string_e) }

    all = frequency.all
    count_all = all.size

    assert_includes(all, string_a)
    assert_includes(all, string_b)
    assert_includes(all, string_c)
    assert_includes(all, string_d)
    assert_includes(all, string_e)

    assert_equal(5, count_all)
  end
end
