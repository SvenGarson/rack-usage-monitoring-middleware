require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageTrackingTrackerAcceptedLanguageTest < Minitest::Test
  def test_that_RackUsageTracking_TrackerAcceptedLanguage_accessible_when_middleware_required
    tracker_accepted_language_accessible = defined?(RackUsageTracking::TrackerAcceptedLanguage)

    assert(tracker_accepted_language_accessible)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_is_subclass_of_Tracker
    is_subclass_of_tracker = (RackUsageTracking::TrackerAcceptedLanguage < RackUsageTracking::Tracker)

    assert_equal(true, is_subclass_of_tracker)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_requirements_met_takes_single_hash_as_argument_and_returns_false
    some_hash = Hash.new
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    requirements_met = tracker_accepted_language.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_requirements_met_does_not_mutate_argument_hash
    some_hash = {'Iron' => 'Man', 'Spider' => 'Boy'}
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_accepted_language.requirements_met?(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_requirements_met_returns_true_when_argument_hash_contains_expected_data
    expected_data_hash = { 'HTTP_ACCEPT_LANGUAGE' => 'language' }
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    requirements_met = tracker_accepted_language.requirements_met?(expected_data_hash)

    assert_equal(true, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_requirements_met_returns_false_when_argument_hash_does_not_contain_expected_data
    some_hash = Hash.new
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    requirements_met = tracker_accepted_language.requirements_met?(some_hash)

    assert_equal(false, requirements_met)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_responds_to_track_data
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    responds_to_track_data = tracker_accepted_language.respond_to?(:track_data)

    assert_equal(true, responds_to_track_data)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_track_data_does_not_mutate_argument_hash
    some_hash = {'HTTP_ACCEPT_LANGUAGE' => 'fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5, ;q=1.0'}
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new
    hash_data_points_before_invocation = Helpers::HashDataPoints.new(some_hash)
    
    tracker_accepted_language.track_data(some_hash)
    hash_data_points_after_invocation = Helpers::HashDataPoints.new(some_hash)
    hashes_identical = (hash_data_points_before_invocation == hash_data_points_after_invocation)

    assert_equal(true, hashes_identical)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_responds_to_least_frequent
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    responds_to_least_frequent = tracker_accepted_language.respond_to?(:least_frequent)

    assert_equal(true, responds_to_least_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_least_frequent_returns_array
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    least_frequent = tracker_accepted_language.least_frequent

    assert_instance_of(Array, least_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_least_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    least_frequent = tracker_accepted_language.least_frequent

    assert_equal([], least_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_least_frequent_returns_array_with_expected_least_frequent_objects
    request_data_hashes = [
      {'HTTP_ACCEPT_LANGUAGE' => 'de;q=0.5'},
      {'HTTP_ACCEPT_LANGUAGE' => 'en;q=0.8'},
      {'HTTP_ACCEPT_LANGUAGE' => 'de;q=0.5'}
    ]
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_language.track_data(request_data_hash)
    end

    least_frequent = tracker_accepted_language.least_frequent

    assert_equal(%w(en), least_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_least_frequent_returns_array_with_all_least_frequent_objects_with_identical_frequency
    request_data_hashes = [
      {'HTTP_ACCEPT_LANGUAGE' => 'de;q=0.1'},
      {'HTTP_ACCEPT_LANGUAGE' => 'fr;q=0.5'},
      {'HTTP_ACCEPT_LANGUAGE' => 'en;q=0.3'},
      {'HTTP_ACCEPT_LANGUAGE' => 'fr;q=0.5'}
    ]
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_language.track_data(request_data_hash)
    end

    least_frequent = tracker_accepted_language.least_frequent

    assert_equal(2, least_frequent.size)
    assert_includes(least_frequent, 'de')
    assert_includes(least_frequent, 'en')
    refute_includes(least_frequent, 'fr')
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_least_frequent_returns_array_with_dupped_least_frequent_objects
    accepted_languages_string = 'fr;q=0.5'

    request_data_hashes = [
      {'HTTP_ACCEPT_LANGUAGE' => accepted_languages_string},
      {'HTTP_ACCEPT_LANGUAGE' => accepted_languages_string},
      {'HTTP_ACCEPT_LANGUAGE' => accepted_languages_string}
    ]
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_language.track_data(request_data_hash)
    end

    least_frequent = tracker_accepted_language.least_frequent

    least_frequent.each do |least_frequent_object|    
      refute_same(least_frequent_object, accepted_languages_string)
    end
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_responds_to_most_frequent
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    responds_to_most_frequent = tracker_accepted_language.respond_to?(:most_frequent)

    assert_equal(true, responds_to_most_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_most_frequent_returns_array
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    most_frequent = tracker_accepted_language.most_frequent

    assert_instance_of(Array, most_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_most_frequent_returns_empty_array_when_no_data_tracked_yet
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    most_frequent = tracker_accepted_language.most_frequent

    assert_equal([], most_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_most_frequent_returns_array_with_expected_most_frequent_objects
    request_data_hashes = [
      {'HTTP_ACCEPT_LANGUAGE' => 'de;q=0.5'},
      {'HTTP_ACCEPT_LANGUAGE' => 'en;q=0.8'},
      {'HTTP_ACCEPT_LANGUAGE' => 'de;q=0.5'}
    ]
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_language.track_data(request_data_hash)
    end

    most_frequent = tracker_accepted_language.most_frequent

    assert_equal(%w(de), most_frequent)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_most_frequent_returns_array_with_all_most_frequent_objects_with_identical_frequency
    request_data_hashes = [
      {'HTTP_ACCEPT_LANGUAGE' => 'de;q=0.1'},
      {'HTTP_ACCEPT_LANGUAGE' => 'fr;q=0.5'},
      {'HTTP_ACCEPT_LANGUAGE' => 'en;q=0.3'},
      {'HTTP_ACCEPT_LANGUAGE' => 'fr;q=0.5'},
      {'HTTP_ACCEPT_LANGUAGE' => 'de;q=0.1'}
    ]
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_language.track_data(request_data_hash)
    end

    most_frequent = tracker_accepted_language.most_frequent

    assert_equal(2, most_frequent.size)
    assert_includes(most_frequent, 'de')
    assert_includes(most_frequent, 'fr')
    refute_includes(most_frequent, 'en')
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_most_frequent_returns_array_with_dupped_most_frequent_objects
    accepted_languages_string = 'fr;q=0.5'

    request_data_hashes = [
      {'HTTP_ACCEPT_LANGUAGE' => accepted_languages_string},
      {'HTTP_ACCEPT_LANGUAGE' => accepted_languages_string},
      {'HTTP_ACCEPT_LANGUAGE' => accepted_languages_string}
    ]
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_language.track_data(request_data_hash)
    end

    most_frequent = tracker_accepted_language.most_frequent

    most_frequent.each do |most_frequent_object|    
      refute_same(most_frequent_object, accepted_languages_string)
    end
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_responds_to_all
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    responds_to_all = tracker_accepted_language.respond_to?(:all)

    assert_equal(true, responds_to_all)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_all_returns_array
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    all = tracker_accepted_language.all

    assert_instance_of(Array, all)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_all_returns_empty_array_when_no_data_tracked_yet
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    all = tracker_accepted_language.all

    assert_equal([], all)
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_all_returns_array_with_all_tracked_objects
    request_data_hashes = [
      {'HTTP_ACCEPT_LANGUAGE' => 'de;q=0.1'},
      {'HTTP_ACCEPT_LANGUAGE' => 'en;q=0.7'},
      {'HTTP_ACCEPT_LANGUAGE' => 'en;q=0.7'},
      {'HTTP_ACCEPT_LANGUAGE' => 'fr;q=0.4'},
      {'HTTP_ACCEPT_LANGUAGE' => 'fr;q=0.4'},
      {'HTTP_ACCEPT_LANGUAGE' => 'fr;q=0.4'},
    ]
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_language.track_data(request_data_hash)
    end

    all = tracker_accepted_language.all

    assert_equal(3, all.size)
    assert_includes(all, 'de')
    assert_includes(all, 'en')
    assert_includes(all, 'fr')
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_all_returns_array_with_tracked_objects_dupped
    accepted_languages_string = 'en;q=0.8'

    request_data_hashes = [
      {'HTTP_ACCEPT_LANGUAGE' => accepted_languages_string},
      {'HTTP_ACCEPT_LANGUAGE' => accepted_languages_string},
      {'HTTP_ACCEPT_LANGUAGE' => accepted_languages_string}
    ]
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    request_data_hashes.each do |request_data_hash|
      tracker_accepted_language.track_data(request_data_hash)
    end

    all = tracker_accepted_language.all

    all.each do |all_object|    
      refute_same(all_object, accepted_languages_string)
    end
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_parses_language_only_string_correctly
    accepted_languages_request_hash = {'HTTP_ACCEPT_LANGUAGE' => 'en'}
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    tracker_accepted_language.track_data(accepted_languages_request_hash)
    all = tracker_accepted_language.all

    assert_same(1, all.size)
    assert_includes(all, 'en')
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_parses_language_with_weight_string_correctly
    accepted_languages_request_hash = {'HTTP_ACCEPT_LANGUAGE' => 'en;q=0.5'}
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    tracker_accepted_language.track_data(accepted_languages_request_hash)
    all = tracker_accepted_language.all

    assert_same(1, all.size)
    assert_includes(all, 'en')
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_parses_wildcard_only_string_correctly
    accepted_languages_request_hash = {'HTTP_ACCEPT_LANGUAGE' => '*'}
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    tracker_accepted_language.track_data(accepted_languages_request_hash)
    all = tracker_accepted_language.all

    assert_same(1, all.size)
    assert_includes(all, '*')
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_parses_wildcard_with_weight_string_correctly
    accepted_languages_request_hash = {'HTTP_ACCEPT_LANGUAGE' => '*;q=0.1'}
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    tracker_accepted_language.track_data(accepted_languages_request_hash)
    all = tracker_accepted_language.all

    assert_same(1, all.size)
    assert_includes(all, '*')
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_parses_no_language_with_weight_string_correctly
    accepted_languages_request_hash = {'HTTP_ACCEPT_LANGUAGE' => ';q=0.5'}
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    tracker_accepted_language.track_data(accepted_languages_request_hash)
    all = tracker_accepted_language.all

    assert_same(1, all.size)
    assert_includes(all, '')
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_parses_empty_string_correctly
    accepted_languages_request_hash = {'HTTP_ACCEPT_LANGUAGE' => ''}
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    tracker_accepted_language.track_data(accepted_languages_request_hash)
    all = tracker_accepted_language.all

    assert_same(1, all.size)
    assert_includes(all, '')
  end

  def test_that_RackUsageTracking_TrackerAcceptedLanguage_parses_multi_language_header_correctly
    accepted_languages = ['en', 'de;q=0.5', '*', 'fr;q=0.1', ';q=0.3'].join(',')
    accepted_languages_request_hash = { 'HTTP_ACCEPT_LANGUAGE' => accepted_languages }
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    tracker_accepted_language.track_data(accepted_languages_request_hash)
    all = tracker_accepted_language.all

    assert_equal(5, all.size)
    assert_includes(all, 'en')
    assert_includes(all, 'de')
    assert_includes(all, '*')
    assert_includes(all, 'fr')
    assert_includes(all, '')
  end

  # ------------------ DONE TILL HERE | I.E CONTINUE UNDER THIS LINE ---------------------
  def test_that_RackUsageTracking_TrackerAcceptedLanguage_parses_multi_language_header_with_leading_and_trailing_whitespace_around_language_correctly
    accepted_languages = [
      '    en',
      'de  ;      q=0.5    ',
      '   *   ',
      '    fr  ;  q=0.1',
      '     ;q=0.3   '
    ].join(',')

    accepted_languages_request_hash = { 'HTTP_ACCEPT_LANGUAGE' => accepted_languages }
    tracker_accepted_language = RackUsageTracking::TrackerAcceptedLanguage.new

    tracker_accepted_language.track_data(accepted_languages_request_hash)
    all = tracker_accepted_language.all

    assert_equal(5, all.size)
    assert_includes(all, 'en')
    assert_includes(all, 'de')
    assert_includes(all, '*')
    assert_includes(all, 'fr')
    assert_includes(all, '')
  end
end
=begin

  More tests:
    (> multi language header separated with comma consistently parsed correctly)
    (> multi language header separated with comma-space consistently parsed correctly)
    > separated with comma but ranodm leading and trailing whitespace
    > multi language header separated with random comma and comma-space consistently parsed correctly
=end 