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
    string_length = RackUsageAttributes::AttributeStringLength.new

    string_length.update()

    assert_equal(false, string_length.has_shortest?)
  end
end

# test_that_RackUsageAttributes_AttributeStringLength
# AttributeStringLength

=begin
  Test to make to AttributeStringLength

  Note:

  To test whether the class works correctly with the huge upper range length of strings, in theory,
  the ceiling needs to be defined and tested against with a shorter string and we must make sure
  that the ceiling used and compared against in the class is the eact same variable.

  That way we could test with a shorter string.

  OR

  We could just drop the max string length down to something reasonable that is expected to be
  processed by the middleware and run tests that way without that problem.

  #update_each
    - does NOT track input strings that are OUTSIDE the range (1..((2^32)-1)
    - updates shortest string when last argument SHORTER than string before
      and OPPOSITE -> does NOT update shortest if the last argument.length >= string before
    - updates longest string when last argument LONGER than string before
      and OPPOSITE -> does NOT update longest if the last argument.length <= string before
  #has_shortest?
    - returns FALSE when UPDATED but argument string OUT OF RANGE
    - returns TRUE when UPDATED and argument string IN RANGE
  #shortest
    - respond
    - returns NIL when #has_shortest? == FALSE
    - returns SHORTEST NON-EMPTY string when #has_shortest? == TRUE
    - returns DUPPED STRING when #has_shortes? == TRUE
  #has_longest?
    - respond
    - returns FALSE when NOT UPDATED
    - returns FALSE when UPDATED but argument string OUT OF RANGE
    - returns TRUE when UPDATED and argument string IN RANGE
  #longest
    - respond
    - returns NIL when #has_longest? == FALSE
    - returns LONGEST NON-EMPTY string when #has_longest? == TRUE
    - returns DUPPED STRING when #has_longest? == TRUE
=end