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

  def test_that_RackUsageAttributes_AttributeRanking_responds_to_lowest
    ranking = RackUsageAttributes::AttributeRanking.new

    assert_equal(true, ranking.respond_to?(:lowest))
  end

  def test_that_RackUsageAttributes_AttributeRanking_lowest_returns_nil_when_has_ranking_returns_false
    ranking = RackUsageAttributes::AttributeRanking.new

    assert_equal(false, ranking.has_ranking?)
    assert_nil(ranking.lowest)
  end

  def test_that_RackUsageAttributes_AttributeRanking_lowest_returns_lowest_ranking_object_when_has_ranking_returns_true
    ranking = RackUsageAttributes::AttributeRanking.new

    http_version_0_9 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9')
    http_version_1_0 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.0')
    http_version_1_1 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.1')
    http_version_2_0 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0')

    ranking.update(http_version_1_1)
    ranking.update(http_version_2_0)
    ranking.update(http_version_0_9)
    ranking.update(http_version_1_0)

    assert_equal(true, ranking.has_ranking?)
    assert_equal(http_version_0_9, ranking.lowest) 
  end

  def test_that_RackUsageAttributes_AttributeRanking_lowest_returns_dupped_lowest_ranking_object_when_has_ranking_returns_true
    ranking = RackUsageAttributes::AttributeRanking.new

    http_version_0_9 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9')
    http_version_1_0 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.0')
    http_version_1_1 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.1')
    http_version_2_0 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0')

    ranking.update(http_version_1_1)
    ranking.update(http_version_2_0)
    ranking.update(http_version_0_9)
    ranking.update(http_version_1_0)

    assert_equal(true, ranking.has_ranking?)
    refute_same(http_version_0_9, ranking.lowest) 
  end

  def test_that_RackUsageAttributes_AttributeRanking_responds_to_highest
    ranking = RackUsageAttributes::AttributeRanking.new

    assert_equal(true, ranking.respond_to?(:highest))
  end

  def test_that_RackUsageAttributes_AttributeRanking_highest_returns_nil_when_has_ranking_returns_false
    ranking = RackUsageAttributes::AttributeRanking.new

    assert_equal(false, ranking.has_ranking?)
    assert_nil(ranking.highest)
  end

  def test_that_RackUsageAttributes_AttributeRanking_highest_returns_highest_ranking_object_when_has_ranking_returns_true
    ranking = RackUsageAttributes::AttributeRanking.new

    http_version_0_9 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9')
    http_version_1_0 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.0')
    http_version_1_1 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.1')
    http_version_2_0 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0')

    ranking.update(http_version_1_1)
    ranking.update(http_version_0_9)
    ranking.update(http_version_2_0)
    ranking.update(http_version_1_0)

    assert_equal(true, ranking.has_ranking?)
    assert_equal(http_version_2_0, ranking.highest) 
  end

  def test_that_RackUsageAttributes_AttributeRanking_highest_returns_dupped_highest_ranking_object_when_has_ranking_returns_true
    ranking = RackUsageAttributes::AttributeRanking.new

    http_version_0_9 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9')
    http_version_1_0 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.0')
    http_version_1_1 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.1')
    http_version_2_0 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0')

    ranking.update(http_version_1_1)
    ranking.update(http_version_0_9)
    ranking.update(http_version_2_0)
    ranking.update(http_version_1_0)

    assert_equal(true, ranking.has_ranking?)
    refute_same(http_version_2_0, ranking.highest) 
  end

  def test_that_RackUsageAttributes_AttributeRanking_responds_to_all
    ranking = RackUsageAttributes::AttributeRanking.new

    assert_equal(true, ranking.respond_to?(:all))
  end

  def test_that_RackUsageAttributes_AttributeRanking_all_returns_empty_array_when_has_ranking_returns_false
    ranking = RackUsageAttributes::AttributeRanking.new

    assert_equal(false, ranking.has_ranking?)
    assert_equal(0, ranking.all.size)
  end

   def test_that_RackUsageAttributes_AttributeRanking_all_returns_array_of_HttpVersion_objects_when_has_ranking_returns_true
    ranking = RackUsageAttributes::AttributeRanking.new

    http_version_0_9 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/0.9')
    http_version_1_0 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.0')
    http_version_1_1 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/1.1')
    http_version_2_0 = RackUsageTrackingHelpers::HttpVersion.new('HTTP/2.0')

    ranking.update(http_version_1_1)
    ranking.update(http_version_0_9)
    ranking.update(http_version_2_0)
    ranking.update(http_version_1_0)

    ranking_all = ranking.all

    assert_equal(true, ranking.has_ranking?)

    ranking_all.each { |http_version| assert_instance_of(RackUsageTrackingHelpers::HttpVersion, http_version, "Object must be instance of HttpVersion") }
    assert_equal(4, ranking.all.size)
  end

=begin
  break these test apart of leave group them togeter?
  Broken apart into parts like for instance:
    - #all has correct count
    - #all returns array of objects that instances of HttpVersion
    - #all returns array without duplicated
    - #update does NOT add HttpVersion duplicates
    - #update DOES add when HttpVersion NOT duplicate
=end
end