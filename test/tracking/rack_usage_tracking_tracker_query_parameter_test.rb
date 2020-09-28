require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageTrackingTrackerQueryParameterTest < Minitest::Test
  def test_that_RackUsageTracking_TrackerQueryParameter_accessible_when_middleware_required
    tracker_query_parameter_accessible = defined?(RackUsageTracking::TrackerQueryParameter)

    assert(tracker_query_parameter_accessible)
  end
  
  def test_that_RackUsageTracking_TrackerQueryParameter_is_subclass_of_Tracker
    is_subclass_of_tracker = (RackUsageTracking::TrackerQueryParameter < RackUsageTracking::Tracker)

    assert_equal(true, is_subclass_of_tracker)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_requirements_met_takes_single_hash_as_argument_and_returns_false
    some_hash = Hash.new
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    requirements_met = tracker_query_parmeter.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_requirements_met_does_not_mutate_argument_hash
    some_hash = {'Iron' => 'Man', 'Spider' => 'Boy'}
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_query_parmeter.requirements_met?(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_requirements_met_returns_true_when_argument_hash_contains_expected_data
    expected_data_hash = { 'QUERY_STRING' => 'query' }
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    requirements_met = tracker_query_parmeter.requirements_met?(expected_data_hash)

    assert_equal(true, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_requirements_met_returns_false_when_argument_hash_does_not_contain_expected_data
    some_hash = Hash.new
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    requirements_met = tracker_query_parmeter.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_responds_to_track_data
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    responds_to_track_data = tracker_query_parmeter.respond_to?(:track_data)

    assert_equal(true, responds_to_track_data)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_track_data_does_not_mutate_argument_hash
    expected_data_hash = {'QUERY_STRING' => 'query'}
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    
    tracker_query_parmeter.track_data(expected_data_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(expected_data_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_responds_to_least_frequent
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    responds_to_least_frequent = tracker_query_parmeter.respond_to?(:least_frequent)

    assert_equal(true, responds_to_least_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_least_frequent_returns_array
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    least_frequent = tracker_query_parmeter.least_frequent

    assert_instance_of(Array, least_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_least_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    least_frequent = tracker_query_parmeter.least_frequent

    assert_equal([], least_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_least_frequent_returns_array_with_expected_least_frequent_query_parameter_instances
    request_data_hashes = [
      {'QUERY_STRING' => '?size=medium'},
      {'QUERY_STRING' => '?size=XXL'},
      {'QUERY_STRING' => '?size=medium'}
    ]
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_parmeter.track_data(request_data_hash)
    end

    least_frequent = tracker_query_parmeter.least_frequent

    assert_equal(1, least_frequent.size)
    assert_includes(least_frequent, RackUsageTrackingHelpers::QueryParameter.new('size=XXL'))
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_least_frequent_returns_array_with_all_least_frequent_query_parameter_instances_with_identical_frequency
    request_data_hashes = [
      {'QUERY_STRING' => '?color=pink'},
      {'QUERY_STRING' => '?color=blue'},
      {'QUERY_STRING' => '?color=magenta'},
      {'QUERY_STRING' => '?color=pink'}
    ]
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_parmeter.track_data(request_data_hash)
    end

    least_frequent = tracker_query_parmeter.least_frequent

    assert_equal(2, least_frequent.size)
    assert_includes(least_frequent, RackUsageTrackingHelpers::QueryParameter.new('color=blue'))
    assert_includes(least_frequent, RackUsageTrackingHelpers::QueryParameter.new('color=magenta'))
    refute_includes(least_frequent, RackUsageTrackingHelpers::QueryParameter.new('color=pink'))
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_responds_to_most_frequent
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    responds_to_most_frequent = tracker_query_parmeter.respond_to?(:most_frequent)

    assert_equal(true, responds_to_most_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_most_frequent_returns_array
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    most_frequent = tracker_query_parmeter.most_frequent

    assert_instance_of(Array, most_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_most_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    most_frequent = tracker_query_parmeter.most_frequent

    assert_equal([], most_frequent)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_most_frequent_returns_array_with_expected_most_frequent_query_parameter_instances
    request_data_hashes = [
      {'QUERY_STRING' => '?choice=99'},
      {'QUERY_STRING' => 'seats=5&model=X'},
      {'QUERY_STRING' => 'choice=99'}
    ]
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_parmeter.track_data(request_data_hash)
    end

    most_frequent = tracker_query_parmeter.most_frequent

    assert_equal(1, most_frequent.size)
    assert_includes(most_frequent, RackUsageTrackingHelpers::QueryParameter.new('choice=99'))
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_most_frequent_returns_array_with_all_most_frequent_query_parameter_instances_with_identical_frequency
    request_data_hashes = [
      {'QUERY_STRING' => '?wheels=2'},
      {'QUERY_STRING' => '?wheels=2'},
      {'QUERY_STRING' => '?auto=ON'},
      {'QUERY_STRING' => '?auto=ON'},
      {'QUERY_STRING' => '?enabled=false'}
    ]
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_parmeter.track_data(request_data_hash)
    end

    most_frequent = tracker_query_parmeter.most_frequent

    assert_equal(2, most_frequent.size)
    assert_includes(most_frequent, RackUsageTrackingHelpers::QueryParameter.new('wheels=2'))
    assert_includes(most_frequent, RackUsageTrackingHelpers::QueryParameter.new('auto=ON'))
    refute_includes(most_frequent, RackUsageTrackingHelpers::QueryParameter.new('enabled=false'))
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_responds_to_all
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    responds_to_all = tracker_query_parmeter.respond_to?(:all)

    assert_equal(true, responds_to_all)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_all_returns_array
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    all = tracker_query_parmeter.all

    assert_instance_of(Array, all)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_all_returns_empty_array_when_no_data_tracked_yet
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    all = tracker_query_parmeter.all

    assert_equal([], all)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_all_returns_array_with_all_tracked_query_parameter_instances
    request_data_hashes = [
      {'QUERY_STRING' => '?name=Jack'},
      {'QUERY_STRING' => '?age=28'},
      {'QUERY_STRING' => '?age=28'},
      {'QUERY_STRING' => '?type=aggressive'},
      {'QUERY_STRING' => '?type=aggressive'},
      {'QUERY_STRING' => '?type=aggressive'}
    ]
    tracker_query_parmeter = RackUsageTracking::TrackerQueryParameter.new

    request_data_hashes.each do |request_data_hash|
      tracker_query_parmeter.track_data(request_data_hash)
    end

    all = tracker_query_parmeter.all

    assert_equal(3, all.size)
    assert_includes(all, RackUsageTrackingHelpers::QueryParameter.new('name=Jack'))
    assert_includes(all, RackUsageTrackingHelpers::QueryParameter.new('age=28'))
    assert_includes(all, RackUsageTrackingHelpers::QueryParameter.new('type=aggressive'))
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_responds_to_has_longest?
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new

    responds_to_has_longest = tracker_query_parameter.respond_to?(:has_longest?)

    assert_equal(true, responds_to_has_longest)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_has_longest_returns_false_when_longest_parameter_string_has_not_yet_been_determined
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new

    has_longest = tracker_query_parameter.has_longest?

    assert_equal(false, has_longest)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_has_longest_returns_true_when_longest_parameter_string_has_been_determined
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new
    request_data_hash = {'QUERY_STRING' => '?super_mario=plumber'}
    tracker_query_parameter.track_data(request_data_hash)

    has_longest = tracker_query_parameter.has_longest?

    assert_equal(true, has_longest)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_responds_to_longest
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new

    responds_to_longest = tracker_query_parameter.respond_to?(:longest)

    assert_equal(true, responds_to_longest)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_longest_returns_nil_when_has_longest_returns_false
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new

    has_longest = tracker_query_parameter.has_longest?
    longest = tracker_query_parameter.longest

    assert_equal(false, has_longest)
    assert_nil(longest)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_longest_returns_longest_query_parameter_instance_when_has_longest_returns_true
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new
    request_data_hash = {'QUERY_STRING' => '?category=bikes'}
    tracker_query_parameter.track_data(request_data_hash)

    has_longest = tracker_query_parameter.has_longest?
    longest = tracker_query_parameter.longest

    assert_equal(true, has_longest)
    assert_equal(RackUsageTrackingHelpers::QueryParameter.new('category=bikes'), longest)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_longest_returns_expected_longest_query_parameter_instance
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new
    request_data_hashes = [
      {'QUERY_STRING' => '?choice=PC'},
      {'QUERY_STRING' => '?country=germany'},
      {'QUERY_STRING' => '?size=XXL'},
      {'QUERY_STRING' => '?best_movie_seen=PursuitOfHappiness'}
    ]

    request_data_hashes.each do |request_data_hash|
      tracker_query_parameter.track_data(request_data_hash)
    end

    longest = tracker_query_parameter.longest

    assert_equal(RackUsageTrackingHelpers::QueryParameter.new('best_movie_seen=PursuitOfHappiness'), longest)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_responds_to_average_per_request
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new

    responds_to_average_per_request = tracker_query_parameter.respond_to?(:average_per_request)

    assert_equal(true, responds_to_average_per_request)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_average_per_request_returns_zero_as_float_when_no_data_tracked_yet
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new

    average_parameters_per_request = tracker_query_parameter.average_per_request

    assert_equal(0.0, average_parameters_per_request)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_average_per_request_returns_expected_average_as_float_when_single_query_parameter_tracked
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new
    request_data_hash = {'QUERY_STRING' => '?hero=Thor'}
    tracker_query_parameter.track_data(request_data_hash)

    average_parameters_per_request = tracker_query_parameter.average_per_request
    expected_average_parameters_per_request = 1.0 / 1.to_f

    assert_equal(expected_average_parameters_per_request, average_parameters_per_request)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_average_per_request_returns_expected_average_as_float_when_variable_parameter_count_query_parameters_tracked
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new
    request_data_hashes = [
      {'QUERY_STRING' => '?k1=v1'},                               # 1. request -> 1 parameter
      {'QUERY_STRING' => '?k1=v1&k2=v2&k3=v3'},                   # 2. request -> 3 parameters
      {'QUERY_STRING' => '?k1=v1&k2=v2&k3=v3&k4=v4&k5=v5&k6=v6'}, # 3. request -> 6 parameters
      {'QUERY_STRING' => '?k1=v1&k2=v2&k3=v3&k4=v4'},             # 4. request -> 4 parameters
      {'QUERY_STRING' => '?k1=v1&k2=v2'}                          # 5. request -> 2 parameters
    ]
    
    request_data_hashes.each do |request_data_hash|
      tracker_query_parameter.track_data(request_data_hash)
    end

    average_parameters_per_request = tracker_query_parameter.average_per_request
    total_requests = 5
    total_parameters_as_float = 0.0
    [1, 3, 6, 4, 2].each do |parameters|
      total_parameters_as_float += parameters.to_f
    end

    expected_average_parameters_per_request = total_parameters_as_float / total_requests.to_f

    assert_equal(expected_average_parameters_per_request, average_parameters_per_request)
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_parses_query_string_correctly_when_prefixed_with_question_mark
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new
    request_data_hash = {'QUERY_STRING' => '?hello=friendo&super=mario'}
    tracker_query_parameter.track_data(request_data_hash)

    all_query_parameters = tracker_query_parameter.all
    query_parameter_count = all_query_parameters.size

    assert_equal(2, query_parameter_count)
    assert_includes(all_query_parameters, RackUsageTrackingHelpers::QueryParameter.new('hello=friendo'))
    assert_includes(all_query_parameters, RackUsageTrackingHelpers::QueryParameter.new('super=mario'))
  end


  def test_that_RackUsageTracking_TrackerQueryParameter_parses_query_string_correctly_when_not_prefixed_with_question_mark
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new
    request_data_hash = {'QUERY_STRING' => 'hello=friendo&super=mario'}
    tracker_query_parameter.track_data(request_data_hash)

    all_query_parameters = tracker_query_parameter.all
    query_parameter_count = all_query_parameters.size

    assert_equal(2, query_parameter_count)
    assert_includes(all_query_parameters, RackUsageTrackingHelpers::QueryParameter.new('hello=friendo'))
    assert_includes(all_query_parameters, RackUsageTrackingHelpers::QueryParameter.new('super=mario'))
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_parses_query_string_parameter_correctly_when_key_is_empty
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new
    request_data_hash = {'QUERY_STRING' => '?=friendo&=mario'}
    tracker_query_parameter.track_data(request_data_hash)

    all_query_parameters = tracker_query_parameter.all
    query_parameter_count = all_query_parameters.size

    assert_equal(2, query_parameter_count)
    assert_includes(all_query_parameters, RackUsageTrackingHelpers::QueryParameter.new('=friendo'))
    assert_includes(all_query_parameters, RackUsageTrackingHelpers::QueryParameter.new('=mario'))
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_parses_query_string_parameter_correctly_when_value_is_empty
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new
    request_data_hash = {'QUERY_STRING' => '?hello=&super='}
    tracker_query_parameter.track_data(request_data_hash)

    all_query_parameters = tracker_query_parameter.all
    query_parameter_count = all_query_parameters.size

    assert_equal(2, query_parameter_count)
    assert_includes(all_query_parameters, RackUsageTrackingHelpers::QueryParameter.new('hello='))
    assert_includes(all_query_parameters, RackUsageTrackingHelpers::QueryParameter.new('super='))
  end

  def test_that_RackUsageTracking_TrackerQueryParameter_to_s_represents_query_parameter_correctly
    tracker_query_parameter = RackUsageTracking::TrackerQueryParameter.new
    request_data_hash = {'QUERY_STRING' => '?category=ABC'}
    tracker_query_parameter.track_data(request_data_hash)

    longest_query_parameter_string = tracker_query_parameter.longest.to_s

    assert_equal('category=ABC', longest_query_parameter_string)
  end
end
