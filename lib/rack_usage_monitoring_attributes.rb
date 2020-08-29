require_relative 'rack_usage_monitoring_helpers'
require 'date'

module RackUsageAttributes
  module UpdateableEach
    def update_each(value=nil); end
  end

  class Attribute
    def update(object=nil)
      objects_array = nil

      if object.instance_of?(Array)
        objects_array = object
      else
        objects_array = [object]
      end

      objects_array.each do |object_to_pass|
        update_each(object_to_pass.dup)
      end

      object
    end
  end

  class AttributeCounter < Attribute
    include UpdateableEach

    attr_reader(:count)

    def initialize
      self.count = 0
    end

    def update_each(value=nil)
      self.count = count + 1
    end

    attr_writer(:count)
  end

  class AttributeCounterDailyReset < Attribute
    include UpdateableEach

    def initialize(now=nil)
      self.date_today = now.nil? ? Time.now : now
      self.daily_counter = AttributeCounter.new
    end

    def update_each(object=nil)
      daily_counter.update
      daily_counter.count
    end

    def today
      daily_counter.count
    end

    private

    attr_writer(:date_today, :daily_counter)
    attr_reader(:daily_counter)
  end

end