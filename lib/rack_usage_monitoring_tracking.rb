require_relative 'rack_usage_monitoring_attributes'

module RackUsageTracking
  module Constants
    KEY_PATH_INFO = 'PATH_INFO'
    KEY_REQUEST_URI = 'REQUEST_URI'
    KEY_HTTP_ACCEPT = 'HTTP_ACCEPT'
    KEY_HTTP_VERSION = 'HTTP_VERSION'
    KEY_QUERY_STRING = 'QUERY_STRING'
    KEY_REQUEST_METHOD = 'REQUEST_METHOD'
    KEY_ACCEPT_LANGUAGE = 'HTTP_ACCEPT_LANGUAGE'
    KEY_ACCEPT_ENCODING = 'HTTP_ACCEPT_ENCODING'
  end

  Constants.freeze

  class Tracker
    def requirements_met?(env)
      false
    end
  end

  class TrackerRegister
    def initialize
      self.tracker_name_instance_hash = Hash.new
    end

    def register(tracker_name, tracker_instance)
      tracker_name_instance_hash[tracker_name] = tracker_instance

      tracker_name
    end

    def update_all(env)
      tracker_name_instance_hash.each_pair do |_, tracker|
        next unless tracker.requirements_met?(env)
        
        tracker.track_data(env)
      end

      env
    end

    def has_tracker_named?(tracker_name)
      tracker_name_instance_hash.has_key?(tracker_name)
    end

    def tracker_named(tracker_name)
      if tracker_name_instance_hash.has_key?(tracker_name)
        tracker_name_instance_hash[tracker_name]
      else
        nil
      end
    end

    private

    attr_accessor(:tracker_name_instance_hash)
  end

  class TrackerRequest < Tracker
    def initialize
      self.counter = RackUsageAttributes::AttributeCounter.new
      self.daily_reset_counter = RackUsageAttributes::AttributeCounterDailyReset.new
    end

    def requirements_met?(env)
      true
    end

    def track_data(env)
      counter.update
      daily_reset_counter.update
    end

    def total
      counter.count
    end

    def today
      daily_reset_counter.today
    end

    private

    attr_accessor(:counter, :daily_reset_counter)
  end

  class TrackerHttpMethod < Tracker
    def initialize
      self.frequency = RackUsageAttributes::AttributeFrequency.new
    end

    def requirements_met?(env)
      env.has_key?(Constants::KEY_REQUEST_METHOD)
    end

    def track_data(env)
      http_method = env[Constants::KEY_REQUEST_METHOD]

      frequency.update(http_method)
    end

    def least_frequent
      frequency.least_frequent
    end

    def most_frequent
      frequency.most_frequent
    end

    def all
      frequency.all
    end

    private

    attr_accessor(:frequency)
  end

  class TrackerAcceptedLanguage < Tracker
    def initialize
      self.frequency = RackUsageAttributes::AttributeFrequency.new
    end

    def requirements_met?(env)
      env.has_key?(Constants::KEY_ACCEPT_LANGUAGE)
    end

    def track_data(env)
      accepted_languages_header = env[Constants::KEY_ACCEPT_LANGUAGE]

      language_strings = languages_without_weights_from(accepted_languages_header)

      # track each language separately
      frequency.update(language_strings)
    end

    def least_frequent
      frequency.least_frequent
    end

    def most_frequent
      frequency.most_frequent
    end

    def all
      frequency.all
    end

    private

    def languages_without_weights_from(accepted_languages_header)
      return '' if accepted_languages_header.empty?

      language_weight_strings = accepted_languages_header.split(/,|, /)

      language_strings = language_weight_strings.map do |language_weight_string|
        language_weight_string.split(';').first
      end

      # remove optional leading and trailing whitespace for each accepted language
      language_strings.map!(&:strip)

      language_strings
    end

    attr_accessor(:frequency)
  end

  class TrackerAcceptedEncoding < Tracker
    def initialize
      self.frequency = RackUsageAttributes::AttributeFrequency.new
    end

    def requirements_met?(env)
      env.has_key?(Constants::KEY_ACCEPT_ENCODING)
    end

    def track_data(env)
      accepted_encodings_header = env[Constants::KEY_ACCEPT_ENCODING]

      encoding_strings = encodings_without_weights_from(accepted_encodings_header)

      # track each language separately
      frequency.update(encoding_strings)
    end

    def least_frequent
      frequency.least_frequent
    end

    def most_frequent
      frequency.most_frequent
    end

    def all
      frequency.all
    end

    private

    def encodings_without_weights_from(accepted_encodings_header)
      return '' if accepted_encodings_header.empty?

      encoding_weight_strings = accepted_encodings_header.split(/,|, /)

      encoding_strings = encoding_weight_strings.map do |encoding_weight_string|
        encoding_weight_string.split(';').first
      end

      # remove optional leading and trailing whitespace for each accepted encoding
      encoding_strings.map!(&:strip)

      encoding_strings
    end

    attr_accessor(:frequency)
  end
  
  class TrackerPath < Tracker
    def initialize
      self.frequency = RackUsageAttributes::AttributeFrequency.new
      self.string_length = RackUsageAttributes::AttributeStringLength.new
    end

    def requirements_met?(env)
      env.has_key?(Constants::KEY_PATH_INFO)
    end

    def track_data(env)
      path_info = env[Constants::KEY_PATH_INFO]

      frequency.update(path_info)
      string_length.update(path_info)
    end

    def least_frequent
      frequency.least_frequent
    end

    def most_frequent
      frequency.most_frequent
    end

    def has_longest?
      string_length.has_longest?
    end

    def longest
      string_length.longest
    end

    private

    attr_accessor(:frequency, :string_length)
  end

  class TrackerQueryString < Tracker
    def initialize
      self.frequency = RackUsageAttributes::AttributeFrequency.new
      self.string_length = RackUsageAttributes::AttributeStringLength.new
    end

    def requirements_met?(env)
      env.has_key?(Constants::KEY_QUERY_STRING)
    end

    def track_data(env)
      query_string = env[Constants::KEY_QUERY_STRING]
    
      frequency.update(query_string)
      string_length.update(query_string)
    end

    def least_frequent
      frequency.least_frequent
    end

    def most_frequent
      frequency.most_frequent
    end

    def has_longest?
      string_length.has_longest?
    end

    def longest
      string_length.longest
    end

    private

    attr_accessor(:frequency, :string_length)
  end

  class TrackerRoute < Tracker
    def initialize
      self.frequency = RackUsageAttributes::AttributeFrequency.new
      self.string_length = RackUsageAttributes::AttributeStringLength.new
    end

    def requirements_met?(env)
      env.has_key?(Constants::KEY_PATH_INFO) &&
      env.has_key?(Constants::KEY_QUERY_STRING)
    end

    def track_data(env)
      path_info = env[Constants::KEY_PATH_INFO]
      query_string = env[Constants::KEY_QUERY_STRING]

      corrected_query_string = case query_string.start_with?('?')
      when true  then query_string
      when false then '?' + query_string
      end

      route = path_info + corrected_query_string

      frequency.update(route)
      string_length.update(route)
    end

    def least_frequent
      frequency.least_frequent
    end

    def most_frequent
      frequency.most_frequent
    end

    def has_longest?
      string_length.has_longest?
    end

    def longest
      string_length.longest
    end

    private

    attr_accessor(:frequency, :string_length)
  end

  class TrackerHttpVersion < Tracker
    def initialize
      self.frequency = RackUsageAttributes::AttributeFrequency.new
      self.ranking = RackUsageAttributes::AttributeRanking.new
    end

    def requirements_met?(env)
      env.has_key?(Constants::KEY_HTTP_VERSION)
    end

    def track_data(env)
      http_version_string = env[Constants::KEY_HTTP_VERSION]
      http_version = RackUsageTrackingHelpers::HttpVersion.new(http_version_string)

      frequency.update(http_version)
      ranking.update(http_version)
    end

    def least_frequent
      frequency.least_frequent
    end

    def most_frequent
      frequency.most_frequent
    end

    def all
      frequency.all
    end

    def has_ranking?
      ranking.has_ranking?
    end

    def lowest
      ranking.lowest
    end

    def highest
      ranking.highest
    end

    private

    attr_accessor(:frequency, :ranking)
  end

  class TrackerQueryParameter < Tracker
    def initialize
      self.frequency = RackUsageAttributes::AttributeFrequency.new
      self.string_length = RackUsageAttributes::AttributeStringLength.new
      self.average = RackUsageAttributes::AttributeNumberAverage.new
    end

    def requirements_met?(env)
      env.has_key?(Constants::KEY_QUERY_STRING)
    end

    def track_data(env)
      query_string = env[Constants::KEY_QUERY_STRING]
      query_parameters = RackUsageTrackingHelpers::QueryParameter.parse_query_string(query_string)
      query_parameter_count = query_parameters.size
      query_parameters_as_strings = query_parameters.map(&:to_s)

      frequency.update(query_parameters)
      string_length.update(query_parameters_as_strings)
      average.update(query_parameter_count)
    end

    def least_frequent
      frequency.least_frequent
    end

    def most_frequent
      frequency.most_frequent
    end

    def all
      frequency.all
    end

    def has_longest?
      string_length.has_longest?
    end

    def longest
      if has_longest?
        longest_query_parameter = string_length.longest
        RackUsageTrackingHelpers::QueryParameter.new(longest_query_parameter)
      else
        nil
      end
    end

    def average_per_request
      average.average
    end

    private

    attr_accessor(:frequency, :string_length, :average)
  end
end