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

    def count
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

    private

    def languages_without_weights_from(accepted_languages_header)
      language_weight_strings = accepted_languages_header.split(/,|, /)

      # remove optional leading and trailing whitespace for each accepted language
      language_weight_strings.map!(&:strip)

      language_strings = language_weight_strings.map do |language_weight_string|
        language_weight_string.split(';').first
      end

      language_strings
    end

    attr_accessor(:frequency)
  end
  class TrackerAcceptedEncoding; end
  class TrackerPath; end
  class TrackerQueryString; end
  class TrackerRoute; end
  class TrackerHttpVersion; end
  class TrackerQueryParameter; end
end