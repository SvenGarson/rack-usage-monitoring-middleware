require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageAttributesAttributeRankingTest < Minitest::Test
  def test_that_RackUsageAttributes_AttributeRanking_accessible_when_middleware_required
    assert(defined?(RackUsageAttributes::AttributeRanking))
  end

  def test_that_RackUsageAttributes_AttributeRanking_is_subclass_of_Attribute
    assert_equal(true, RackUsageAttributes::AttributeRanking < RackUsageAttributes::Attribute)
  end

  def test_that_RackUsageAttributes_AttributeRanking_mixes_in_UpdateableEach
    assert_equal(true,
                 Helpers.class_includes_modules(RackUsageAttributes::AttributeRanking, RackUsageAttributes::UpdateableEach)
                )
  end

  # DONE TIL HERE

  def test_that_RackUsageAttributes_AttributeRanking_update_works_without_any_arguments_and_returns_nil
    assert_nil(RackUsageAttributes::AttributeRanking.new.update)
  end

  def test_that_RackUsageAttributes_AttributeRanking_update_can_take_single_argument_and_returns_original_argument
    passed_object = 'hello'

    return_value = RackUsageAttributes::AttributeRanking.new.update(passed_object)

    assert_same(passed_object, return_value)
  end

  def test_that_RackUsageAttributes_AttributeRanking_responds_to_update_each
    assert_equal(true, RackUsageAttributes::AttributeRanking.new.respond_to?(:update_each))
  end

  def test_that_RackUsageAttributes_AttributeRanking_update_each_returns_original_argument
    ranking = RackUsageAttributes::AttributeRanking.new
    passed_argument = 'greetings'

    assert_same(passed_argument, ranking.update_each(passed_argument))
  end

=begin
  Test for update_each:
    - adds arg to set if NOT a duplicate of object in set
    - does NOT add arg to set if object IS a duplicate in set
=end

  def test_that_RackUsageAttributes_AttributeRanking_responds_to_has_ranking
    assert_equal(true, RackUsageAttributes::AttributeRanking.new.respond_to?(:has_ranking?))
  end

  def test_that_RackUsageAttributes_AttributeRanking_has_ranking_returns_false_when_ranking_not_yet_updated_with_an_object
    ranking = RackUsageAttributes::AttributeRanking.new

    has_ranking = ranking.has_ranking?

    assert_equal(false, has_ranking)
  end

  def test_that_RackUsageAttributes_AttributeRanking_has_ranking_returns_true_when_ranking_already_updated_with_an_object
    ranking = RackUsageAttributes::AttributeRanking.new
    ranking.update('rank me please')

    has_ranking = ranking.has_ranking?

    assert_equal(true, has_ranking)
  end

=begin
  Tests for #lowest:
    - responds to
    - returns nil if has_ranking == false
    - returns correct lowest ranking object DUPPED if has_Ranking == true
=end
end