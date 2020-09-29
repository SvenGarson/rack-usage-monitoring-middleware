require 'bundler/setup'
require_relative 'rack_usage_monitoring_tracking'
require 'rack'

module RackUsageMonitoring

  module Constants
    KEY_USAGE_DATA_PROTECTED = "rack_usage_monitoring.usage_data_protected".to_sym
    KEY_RACK_ENV = 'RACK_ENV'
    RACK_ENV_NONE = 'none'
    RACK_ENV_DEVELOPMENT = 'development'
    RACK_ENV_DEPLOYMENT = 'deployment'
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

    def accepted_languages
      RackUsageTracking::TrackerAcceptedLanguage.new
    end

    def accepted_encodings
      RackUsageTracking::TrackerAcceptedEncoding.new
    end

    def paths
      RackUsageTracking::TrackerPath.new
    end

    def query_strings
      RackUsageTracking::TrackerQueryString.new
    end

    def routes
      RackUsageTracking::TrackerRoute.new
    end

    def http_versions
      RackUsageTracking::TrackerHttpVersion.new
    end

    def parameters
      RackUsageTracking::TrackerQueryParameter.new
    end
  end

  def self.usage_data(env)
    env[Constants::KEY_USAGE_DATA_PROTECTED]
  end

  class Middleware
    def initialize(superseeding_rack_application)
      @usage_data = UsageData.new
      @superseeding_rack_application = superseeding_rack_application
    end

    def call(env)
      env[Constants::KEY_USAGE_DATA_PROTECTED] = UsageDataProtected.new

      @superseeding_rack_application.call(env)
    end

    def self.deployment?
      ENV[Constants::KEY_RACK_ENV] == Constants::RACK_ENV_DEPLOYMENT
    end
  end
end