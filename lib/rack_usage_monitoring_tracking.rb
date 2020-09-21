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

    def track(env)
      env
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
    def requirements_met?(env)
      true
    end

    def track_data(env)
      true
    end
  end
  class TrackerHttpMethod; end
  class TrackerAcceptedLanguage; end
  class TrackerAcceptedEncoding; end
  class TrackerPath; end
  class TrackerQueryString; end
  class TrackerRoute; end
  class TrackerHttpVersion; end
  class TrackerQueryParameter; end
end