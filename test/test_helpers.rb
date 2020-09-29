require 'securerandom'

module Helpers
  class DummyEndware
    def call(env)
      Rack::Response.new.finish
    end
  end

  class RackUsageMonitoringWrapper
    attr_reader(:usage_data_protected)

    def initialize(endware)
      self.usage_monitoring_middleware = RackUsageMonitoring::Middleware.new(endware)
      self.usage_data_protected = usage_monitoring_middleware.usage_data_protected
    end

    def call(env)
      # #call(env) rack usage middleware which has the following effects:
      # 1. rack usage middleware tracks data and adds ProtectedUsageData object to env hash
      # 2. rack usage middleware propagates #call(env) to endware
      # 3. rack usage middleware returns the response returned from endware#call
      endware_response = usage_monitoring_middleware.call(env)

      # keep a reference of the UsageDataProtected the middleware just generated
      self.usage_data_protected = RackUsageMonitoring::usage_data(env)

      # return the endware response
      endware_response
    end

    private

    attr_writer(:usage_data_protected)
    attr_accessor(:usage_monitoring_middleware)
  end

  def self.middleware_usage_data_protected_access_wrapper
    endware = DummyEndware.new
    RackUsageMonitoringWrapper.new(endware)
  end

  class DummyTracker
    def initialize(requirements_met:)
      @requirements_met = requirements_met
      @track_data_invoked = false
    end

    def requirements_met?(env)
      @requirements_met
    end

    def track_data(env)
      @track_data_invoked = true
    end

    def track_data_invoked?
      @track_data_invoked
    end
  end

  class EndwareRandomUUID
    attr_reader(:uuid)

    def initialize
      @uuid = SecureRandom.uuid
    end

    def call(env)
      uuid
    end
  end

  class Endware
    def call(env)
      nil
    end
  end

  def self.endware_that_returns_random_uuid_on_call
    EndwareRandomUUID.new
  end

  def self.endware_that_responds_to_call
    Endware.new
  end

  def self.class_includes_modules(class_name, *modules_to_be_mixed_in)
    modules_mixed_in_by_class = class_name.included_modules

    modules_to_be_mixed_in.all? do |module_name|
      modules_mixed_in_by_class.include?(module_name)
    end
  end

  class HashDataPoints
    attr_reader(:id, :size, :dupped_keys, :dupped_values)
    attr_reader(:key_ids, :value_ids)

    def initialize(hash)
      parse_hash_data_points(hash)
    end

    def ==(other)
      id            == other.id            &&
      size          == other.size          &&
      dupped_keys   == other.dupped_keys   &&
      dupped_values == other.dupped_values &&
      key_ids       == other.key_ids       &&
      value_ids     == other.value_ids
    end

    private

    def parse_hash_data_points(hash)
      self.id            = hash.object_id
      self.size          = hash.size
      self.dupped_keys   = hash.keys.map(&:dup)
      self.dupped_values = hash.values.map(&:dup)
      self.key_ids       = hash.keys.map(&:object_id)
      self.value_ids     = hash.values.map(&:object_id)
    end

    attr_writer(:id, :size, :dupped_keys, :dupped_values)
    attr_writer(:key_ids, :value_ids)
  end
end