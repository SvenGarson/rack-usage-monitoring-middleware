# bundler setup goes into
require 'bundler/setup'
require_relative 'rack_usage_monitoring_tracking'

module RackUsageMonitoring

  module Constants
    KEY_USAGE_DATA_PROTECTED = "rack_usage_monitoring.usage_data_protected".to_sym
  end
  Constants.freeze

  class UsageDataBase

  end

  class UsageData < UsageDataBase
    def update(env)
      env
    end
  end

  class UsageDataProtected < UsageDataBase
    def requests
      RackUsageTracking::TrackerRequest.new
    end

    def http_methods
      RackUsageTracking::TrackerHttpMethod.new
    end
    def accepted_languages; end
    def accepted_encodings; end
    def paths; end
    def query_strings; end
    def routes; end
    def http_versions; end
    def parameters; end
  end

  def self.usage_data(env)
    env[Constants::KEY_USAGE_DATA_PROTECTED]
  end

  class Middleware
    def initialize
      @usage_data = UsageData.new
    end

    def call(env)
      env[Constants::KEY_USAGE_DATA_PROTECTED] = UsageDataProtected.new
    end
  end
end