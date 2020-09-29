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
    protected

    attr_accessor(:tracker_register)
  end

  class UsageData < UsageDataBase
    def initialize
      self.tracker_register = RackUsageTracking::TrackerRegister.new
      add_trackers
    end

    def update(env)
      tracker_register.update_all(env)
    end

    private

    def add_trackers
      tracker_register.register(:requests, RackUsageTracking::TrackerRequest.new)
      tracker_register.register(:http_methods, RackUsageTracking::TrackerHttpMethod.new)
    end
  end

  class UsageDataProtected < UsageDataBase
    def initialize(unprotected_usage_data)
      self.protected_usage_data = unprotected_usage_data
    end

    def method_missing(tracker_name, *args)
      # return the tracker instance associated with the missing
      # message name, i.e. tracker name, if it is registered
      tracker_register = protected_usage_data.tracker_register
      has_tracker = tracker_register.has_tracker_named?(tracker_name)

      if has_tracker
        tracker_register.tracker_named(tracker_name)
      else
        super
      end
    end

    private

    attr_accessor(:protected_usage_data)
  end

  def self.usage_data(env)
    env[Constants::KEY_USAGE_DATA_PROTECTED]
  end

  class Middleware
    def initialize(superseeding_rack_application)
      self.usage_data = UsageData.new
      self.superseeding_rack_application = superseeding_rack_application
    end

    def call(env)
      # make each tracker instance track data
      usage_data.update(env)

      # add usage data protected to the env hash so the
      # next rack application in the stack can access that data
      env[Constants::KEY_USAGE_DATA_PROTECTED] = usage_data_protected

      superseeding_rack_application.call(env)
    end

    def usage_data_protected
      UsageDataProtected.new(usage_data)
    end

    def self.deployment?
      ENV[Constants::KEY_RACK_ENV] == Constants::RACK_ENV_DEPLOYMENT
    end

    private

    attr_accessor(:usage_data, :superseeding_rack_application)
  end
end