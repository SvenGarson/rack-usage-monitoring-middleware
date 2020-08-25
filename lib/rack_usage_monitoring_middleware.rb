require 'bundler/setup'

module RackUsageMonitoring

  module Constants

  end

  class UsageData

  end

  class UsageDataProtected < UsageData

  end

  def self.usage_data(env)
    nil
  end

  class Middleware
    def call(env)
    end
  end
end