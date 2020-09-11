require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageAttributesAttributeStringLengthTest < Minitest::Test
  def test_that_RackUsageAttributes_AttributeStringLength_accessible_when_middleware_required
    assert(defined?(RackUsageAttributes::AttributeStringLength))
  end

  def test_that_RackUsageAttributes_AttributeStringLength_is_subclass_of_Attribute
    assert_equal(true, RackUsageAttributes::AttributeStringLength < RackUsageAttributes::Attribute)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_mixes_in_UpdateableEach
    assert_equal(true,
                 Helpers.class_includes_modules(RackUsageAttributes::AttributeStringLength, RackUsageAttributes::UpdateableEach)
                )
  end

  def test_that_RackUsageAttributes_AttributeStringLength_update_works_without_any_arguments_and_returns_nil
    assert_nil(RackUsageAttributes::AttributeStringLength.new.update)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_update_can_take_single_argument_and_returns_original_argument
    passed_object = 'we shall meet again'

    return_value = RackUsageAttributes::AttributeStringLength.new.update(passed_object)

    assert_same(passed_object, return_value)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_responds_to_update_each
    assert_equal(true, RackUsageAttributes::AttributeStringLength.new.respond_to?(:update_each))
  end

  def test_that_RackUsageAttributes_AttributeStringLength_update_each_returns_original_argument
    string_length = RackUsageAttributes::AttributeStringLength.new

    passed_object = 'what is my length'
    return_value = string_length.update_each(passed_object)

    assert_same(passed_object, return_value)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_responds_to_has_shortest
    string_length = RackUsageAttributes::AttributeStringLength.new

    assert_equal(true, string_length.respond_to?(:has_shortest?))
  end

  def test_that_RackUsageAttributes_AttributeStringLength_has_shortest_returns_false_when_not_yet_updated
    string_length = RackUsageAttributes::AttributeStringLength.new

    assert_equal(false, string_length.has_shortest?)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_has_shortest_returns_false_when_updated_with_out_of_range_string
    string_length_zero = RackUsageAttributes::AttributeStringLength.new
    string_length_exceeds = RackUsageAttributes::AttributeStringLength.new

    string_length_zero.update(String.new)
    string_length_exceeds.update(object_that_responds_to_length_which_returns_integer_that_exceeds_max_length)

    zero_has_shortest = string_length_zero.has_shortest?
    exceeds_has_shortest = string_length_exceeds.has_shortest?

    assert_equal(false, zero_has_shortest)
    assert_equal(false, exceeds_has_shortest)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_has_shortest_returns_true_when_updated_with_in_range_string
    string_length_in_range = RackUsageAttributes::AttributeStringLength.new
    string_length_in_range.update('key=value')

    in_range_has_shortest = string_length_in_range.has_shortest?

    assert_equal(true, in_range_has_shortest)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_responds_to_shortest
    string_length = RackUsageAttributes::AttributeStringLength.new

    assert_equal(true, string_length.respond_to?(:shortest))
  end

  def test_that_RackUsageAttributes_AttributeStringLength_shortest_returns_nil_when_has_shortest_returns_false
    string_length = RackUsageAttributes::AttributeStringLength.new

    has_shortest = string_length.has_shortest?
    shortest = string_length.shortest

    assert_equal(false, has_shortest)
    assert_nil(shortest)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_shortest_returns_shortest_string_when_has_shortest_returns_true
    string_length = RackUsageAttributes::AttributeStringLength.new

    longest_string = 'Clearly I am not the hero type'
    another_string = 'What if I was Iron Man'
    shortest_string = 'I am Iron man'

    string_length.update(longest_string)
    string_length.update(another_string)
    string_length.update(shortest_string)

    has_shortest = string_length.has_shortest?
    shortest = string_length.shortest

    assert_equal(true, has_shortest)
    assert_equal(shortest_string, shortest)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_shortest_returns_dupped_string_when_has_shortest_returns_true
    string_length = RackUsageAttributes::AttributeStringLength.new

    some_string = 'I like money'
    string_length.update(some_string)

    has_shortest = string_length.has_shortest?
    shortest = string_length.shortest

    assert_equal(true, has_shortest)
    refute_same(shortest, some_string)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_detects_single_character_strings_as_shortest_string
    string_length = RackUsageAttributes::AttributeStringLength.new

    one_character_string = 'A'
    string_length.update(one_character_string)

    shortest = string_length.shortest

    assert_equal(one_character_string, shortest)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_does_update_shortest_string_when_update_string_has_same_length
    string_length = RackUsageAttributes::AttributeStringLength.new

    string_uppercase = 'ABCDEFG'
    string_lowercase = 'abcdefg'

    string_length.update(string_uppercase)
    first_shortest = string_length.shortest

    string_length.update(string_lowercase)
    second_shortest = string_length.shortest

    assert_equal(string_uppercase, first_shortest)
    assert_equal(string_lowercase, second_shortest)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_shortest_returns_expected_shortest_string
    string_length = RackUsageAttributes::AttributeStringLength.new

    words = %w(Trendy Engineering Bag Fool Dad Birdnest Cab Programming)
    string_length.update(words)
    first_shortest = string_length.shortest

    string_length.update('Fa')
    second_shortest = string_length.shortest

    string_length.update('Baltimore')
    third_shortest = string_length.shortest

    string_length.update('X')
    fourth_shortest = string_length.shortest

    string_length.update('Z')
    fifth_shortest = string_length.shortest

    assert_equal('Cab', first_shortest)
    assert_equal('Fa', second_shortest)
    assert_equal('Fa', third_shortest)
    assert_equal('X', fourth_shortest)
    assert_equal('Z', fifth_shortest)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_responds_to_has_longest
    string_length = RackUsageAttributes::AttributeStringLength.new

    assert_equal(true, string_length.respond_to?(:has_longest?))
  end

  def test_that_RackUsageAttributes_AttributeStringLength_has_longest_returns_false_when_not_yet_updated
    string_length = RackUsageAttributes::AttributeStringLength.new

    assert_equal(false, string_length.has_longest?)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_has_longest_returns_false_when_updated_with_out_of_range_string
    string_length_zero = RackUsageAttributes::AttributeStringLength.new
    string_length_exceeds = RackUsageAttributes::AttributeStringLength.new

    string_length_zero.update(String.new)
    string_length_exceeds.update(object_that_responds_to_length_which_returns_integer_that_exceeds_max_length)

    zero_has_longest = string_length_zero.has_longest?
    exceeds_has_longest = string_length_exceeds.has_longest?

    assert_equal(false, zero_has_longest)
    assert_equal(false, exceeds_has_longest)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_has_longest_returns_true_when_updated_with_in_range_string
    string_length_in_range = RackUsageAttributes::AttributeStringLength.new
    string_length_in_range.update('key=value')

    in_range_has_longest = string_length_in_range.has_longest?

    assert_equal(true, in_range_has_longest)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_responds_to_longest
    string_length = RackUsageAttributes::AttributeStringLength.new

    assert_equal(true, string_length.respond_to?(:longest))
  end

  def test_that_RackUsageAttributes_AttributeStringLength_longest_returns_nil_when_has_longest_returns_false
    string_length = RackUsageAttributes::AttributeStringLength.new

    has_longest = string_length.has_longest?
    longest = string_length.longest

    assert_equal(false, has_longest)
    assert_nil(longest)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_longest_returns_longest_string_when_has_longest_returns_true
    string_length = RackUsageAttributes::AttributeStringLength.new

    shortest_string = 'I am Iron man'
    another_string = 'What if I was Iron Man'
    longest_string = 'Clearly I am not the hero type'

    string_length.update(shortest_string)
    string_length.update(another_string)
    string_length.update(longest_string)

    has_longest = string_length.has_longest?
    longest = string_length.longest

    assert_equal(true, has_longest)
    assert_equal(longest_string, longest)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_longest_returns_dupped_string_when_has_longest_returns_true
    string_length = RackUsageAttributes::AttributeStringLength.new

    some_string = 'I like money even more than you'
    string_length.update(some_string)

    has_longest = string_length.has_longest?
    longest = string_length.longest

    assert_equal(true, has_longest)
    refute_same(longest, some_string)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_detects_single_character_strings_as_longest_string
    string_length = RackUsageAttributes::AttributeStringLength.new

    one_character_string = 'A'
    string_length.update(one_character_string)

    longest = string_length.longest

    assert_equal(one_character_string, longest)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_does_update_longest_string_when_update_string_has_same_length
    string_length = RackUsageAttributes::AttributeStringLength.new

    string_uppercase = 'ABCDEFG'
    string_lowercase = 'abcdefg'

    string_length.update(string_uppercase)
    first_longest = string_length.longest

    string_length.update(string_lowercase)
    second_longest = string_length.longest

    assert_equal(string_uppercase, first_longest)
    assert_equal(string_lowercase, second_longest)
  end

  def test_that_RackUsageAttributes_AttributeStringLength_longest_returns_expected_longest_string
    string_length = RackUsageAttributes::AttributeStringLength.new

    words = %w(Me Car You Street Ravens Programming Short)
    string_length.update(words)
    first_longest = string_length.longest

    string_length.update('Programming More')
    second_longest = string_length.longest

    string_length.update('Eat')
    third_longest = string_length.longest

    string_length.update('Programming Much More')
    fourth_longest = string_length.longest

    assert_equal('Programming', first_longest)
    assert_equal('Programming More', second_longest)
    assert_equal('Programming More', third_longest)
    assert_equal('Programming Much More', fourth_longest)
  end

  def test_that_exceeding_length_string_replacement_object_responds_to_length
    dummy_string = object_that_responds_to_length_which_returns_integer_that_exceeds_max_length

    assert(true, dummy_string.respond_to?(:length))
  end

  def test_that_exceeding_length_string_replacement_object_length_returns_expected_integer_value
    dummy_string = object_that_responds_to_length_which_returns_integer_that_exceeds_max_length

    assert_equal(2**32, dummy_string.length)
  end

  def test_that_matching_length_string_replacement_object_responds_to_length
    dummy_string = object_that_responds_to_length_which_returns_integer_that_matches_max_length

    assert(true, dummy_string.respond_to?(:length))
  end

  def test_that_matching_length_string_replacement_object_length_returns_expected_integer_value
    dummy_string = object_that_responds_to_length_which_returns_integer_that_matches_max_length

    assert(true, (2**32) - 1)
  end

  private

  class RespondsToLengthForValue
    def initialize(value)
      @value = value
    end

    def length
      @value
    end
  end

  def object_that_responds_to_length_which_returns_integer_that_exceeds_max_length
    RespondsToLengthForValue.new(2**32)
  end

  def object_that_responds_to_length_which_returns_integer_that_matches_max_length
    RespondsToLengthForValue.new((2**32) - 1)
  end
end