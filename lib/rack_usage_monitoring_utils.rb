require_relative 'rack_usage_monitoring_middleware'
require 'date'

module RackUsageUtils
  class OverrideableDate
    @@use_date = nil

    def self.set_today_date(date)
      @@use_date = date.dup
      date
    end

    def self.today
      date = @@use_date.dup

      if RackUsageMonitoring::Middleware.deployment? || date.nil?
        Date.today
      else
        date
      end
    end
  end
end
