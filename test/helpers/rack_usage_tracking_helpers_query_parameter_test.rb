require_relative '../test_prerequisites'

class RackUsageTrackingHelpersQueryParameterTest < Minitest::Test
  # namespace
  def test_that_RackUsageTrackingHelpers_QueryParameter_accessible_when_middleware_required
    assert(defined?(RackUsageTrackingHelpers::QueryParameter))
  end

  # new
  def test_that_RackUsageTrackingHelpers_QueryParameter_new_takes_single_string_argument
    assert_instance_of(RackUsageTrackingHelpers::QueryParameter, RackUsageTrackingHelpers::QueryParameter.new(String.new))
  end

  # key
  def test_that_RackUsageTrackingHelpers_QueryParameter_responds_to_key
    assert_respond_to(RackUsageTrackingHelpers::QueryParameter.new(String.new), :key)
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_key_returns_string
    assert_instance_of(String, RackUsageTrackingHelpers::QueryParameter.new(String.new).key)
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_key_returns_empty_string_when_query_string_equal_character_count_not_1
    query_parameter_list = [
      RackUsageTrackingHelpers::QueryParameter.new('menu==pizza'),
      RackUsageTrackingHelpers::QueryParameter.new('=menu=pizza'),
      RackUsageTrackingHelpers::QueryParameter.new('menu=pizza='),
      RackUsageTrackingHelpers::QueryParameter.new('=menu=pizza='),
      RackUsageTrackingHelpers::QueryParameter.new('=menu==pizza='),
      RackUsageTrackingHelpers::QueryParameter.new('==menu=pizza=='),
      RackUsageTrackingHelpers::QueryParameter.new('==menu==pizza==')
    ]

    query_parameter_list.each do |query_parameter|
      assert_equal('', query_parameter.key)
    end
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_key_returns_empty_string_when_key_is_empty
    query_parameter = RackUsageTrackingHelpers::QueryParameter.new('=pizza')

    key = query_parameter.key

    assert_equal('', key)
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_key_returns_correct_string_when_key_not_empty
    query_parameter = RackUsageTrackingHelpers::QueryParameter.new('menu=pizza')

    key = query_parameter.key

    assert_equal('menu', key)
  end

  # #value
  def test_that_RackUsageTrackingHelpers_QueryParameter_responds_to_value
    assert_respond_to(RackUsageTrackingHelpers::QueryParameter.new(String.new), :value)
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_value_returns_string
    assert_instance_of(String, RackUsageTrackingHelpers::QueryParameter.new(String.new).value)
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_value_returns_empty_string_when_query_string_equal_character_count_not_1
    query_parameter_list = [
      RackUsageTrackingHelpers::QueryParameter.new('menu==pizza'),
      RackUsageTrackingHelpers::QueryParameter.new('=menu=pizza'),
      RackUsageTrackingHelpers::QueryParameter.new('menu=pizza='),
      RackUsageTrackingHelpers::QueryParameter.new('=menu=pizza='),
      RackUsageTrackingHelpers::QueryParameter.new('=menu==pizza='),
      RackUsageTrackingHelpers::QueryParameter.new('==menu=pizza=='),
      RackUsageTrackingHelpers::QueryParameter.new('==menu==pizza==')
    ]

    query_parameter_list.each do |query_parameter|
      assert_equal('', query_parameter.value)
    end
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_value_returns_empty_string_when_value_is_empty
    query_parameter = RackUsageTrackingHelpers::QueryParameter.new('menu=')

    value = query_parameter.value

    assert_equal('', value)
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_value_returns_correct_string_when_value_not_empty
    query_parameter = RackUsageTrackingHelpers::QueryParameter.new('menu=pizza')

    value = query_parameter.value

    assert_equal('pizza', value)
  end

  # dup
  def test_that_RackUsageTrackingHelpers_QueryParameter_responds_to_dup
    assert_respond_to(RackUsageTrackingHelpers::QueryParameter.new(String.new), :dup)
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_dup_returns_QueryParameter
    assert_instance_of(RackUsageTrackingHelpers::QueryParameter,
                       RackUsageTrackingHelpers::QueryParameter.new(String.new).dup)
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_dup_returns_new_QueryParameter_instance
    query_parameter = RackUsageTrackingHelpers::QueryParameter.new(String.new)
    query_parameter_dup = query_parameter.dup

    refute_same(query_parameter, query_parameter_dup)
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_dup_matches_original_key_and_value
    query_parameter = RackUsageTrackingHelpers::QueryParameter.new('color=magenta')
    query_parameter_dup = query_parameter.dup

    assert_equal(query_parameter.key, query_parameter_dup.key)
    assert_equal(query_parameter.value, query_parameter_dup.value)
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_key_cannot_be_used_to_change_internal_key_string
    query_parameter = RackUsageTrackingHelpers::QueryParameter.new('color=blue')
    first_key = query_parameter.key

    first_key.replace('brand')  

    second_key = query_parameter.key

    assert_equal('brand', first_key)
    refute_equal('brand', second_key)
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_value_cannot_be_used_to_change_internal_value_string
    query_parameter = RackUsageTrackingHelpers::QueryParameter.new('color=blue')
    first_value = query_parameter.value

    first_value.replace('light-blue')  

    second_value = query_parameter.value

    assert_equal('light-blue', first_value)
    refute_equal('light-blue', second_value)
  end

  # ::parse_query_string
  def test_that_RackUsageTrackingHelpers_QueryParameter_responds_to_parse_query_string
    assert_respond_to(RackUsageTrackingHelpers::QueryParameter, :parse_query_string)
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_parse_query_string_takes_single_string_argument
    assert_instance_of(Array, RackUsageTrackingHelpers::QueryParameter.parse_query_string(String.new))
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_parse_query_string_returns_array_of_QueryParameter_instances
    query_parameter_list = RackUsageTrackingHelpers::QueryParameter.parse_query_string('?menu=pizza&drink=water')

    query_parameter_list.each do |query_parameter|
      assert_instance_of(RackUsageTrackingHelpers::QueryParameter, query_parameter)
    end
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_parse_query_string_returns_correct_number_of_query_parameters
    query_parameter_with_expected_count_list = [
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string(''), 0],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('?'), 0],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('menu=pizza'), 1],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('?menu=pizza'), 1],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('menu=pizza&drink=water'), 2],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('?menu=pizza&drink=water'), 2],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('menu=pizza&drink=water&key='), 3],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('?menu=pizza&drink=water&key='), 3],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('menu=pizza&drink=water&key=&=value'), 4],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('?menu=pizza&drink=water&key=&=value'), 4],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('menu=pizza&drink=water&key=&=value&'), 5],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('?menu=pizza&drink=water&key=&=value&'), 5],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('menu=pizza&drink=water&key=&=value&&'), 6],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('?menu=pizza&drink=water&key=&=value&&'), 6],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('&' * 17), 18],
      [RackUsageTrackingHelpers::QueryParameter.parse_query_string('?' + ('&' * 17)), 18]
    ]

    query_parameter_with_expected_count_list.each do |query_parameter, expected_parameter_count|
      assert_equal(expected_parameter_count, query_parameter.size)  
    end
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_parse_query_string_ignores_leading_question_mark
    query_parameter_list = RackUsageTrackingHelpers::QueryParameter.parse_query_string('?menu=pizza')
    query_string_count = query_parameter_list.size 
    query_parameter = query_parameter_list.first

    assert_equal(1, query_string_count)
    assert_equal(false, query_parameter.key.start_with?('?'))
  end

  def test_that_RackUsageTrackingHelpers_QueryParameter_parse_query_string_works_without_leading_question_mark
    query_parameter_list = RackUsageTrackingHelpers::QueryParameter.parse_query_string('menu=pizza&drink=water')
    
    assert_equal('menu',  query_parameter_list.first.key)
    assert_equal('pizza', query_parameter_list.first.value)
    assert_equal('drink', query_parameter_list.last.key)
    assert_equal('water', query_parameter_list.last.value)
  end
end

=begin

  > testing dupes stuff
  - original = get value
  - try mem change the original
  - new_original = get value again the same way
  - check if new original changed based on mem change

  > format
    > instance + init
      - init
      - responds to
      - argument -> invoke fot specific instance
      - other tests
    > class methods

  > method in general
    - responds to
    - takes x arguments -> invoke the method + get return type
    - return type
    - return range/specific value
    - side effects
  
  >::new
    - 

=end

=begin
  def test_that_RackUsageTrackingHelpers_HttpVersion_responds_to_major
    assert_respond_to(http_version_0_9, :major)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_0_9_major
    major = http_version_0_9.major

    assert_instance_of(Integer, major)
    assert_equal(0, major)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_1_0_major
    major = http_version_1_0.major

    assert_instance_of(Integer, major)
    assert_equal(1, major)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_1_1_major
    major = http_version_1_1.major

    assert_instance_of(Integer, major)
    assert_equal(1, major)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_2_0_major
    major = http_version_2_0.major

    assert_instance_of(Integer, major)
    assert_equal(2, major)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_responds_to_minor
    assert_respond_to(http_version_0_9, :minor)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_0_9_minor
    minor = http_version_0_9.minor

    assert_instance_of(Integer, minor)
    assert_equal(9, minor)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_1_0_minor
    minor = http_version_1_0.minor

    assert_instance_of(Integer, minor)
    assert_equal(0, minor)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_1_1_minor
    minor = http_version_1_1.minor

    assert_instance_of(Integer, minor)
    assert_equal(1, minor)
  end

  def test_that_RackUsageTrackingHelpers_HttpVersion_returns_expected_http_2_0_minor
    minor = http_version_2_0.minor

    assert_instance_of(Integer, minor)
    assert_equal(0, minor)
  end

  private

  attr_reader(:http_version_0_9, :http_version_1_0, :http_version_1_1, :http_version_2_0)
=end

