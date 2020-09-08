require_relative 'rack_usage_monitoring_helpers'
require_relative 'rack_usage_monitoring_utils'

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

    def initialize
      self.counter_date = RackUsageUtils::OverrideableDate.today
      self.daily_counter = AttributeCounter.new
    end

    def update_each(object=nil)
      daily_counter.update

      # reset counter if date changes
      if RackUsageUtils::OverrideableDate.today != counter_date
        self.daily_counter = AttributeCounter.new
        self.counter_date = RackUsageUtils::OverrideableDate.today
      end

      daily_counter.count
    end

    def today
      daily_counter.count
    end

    private

    attr_writer(:counter_date, :daily_counter)
    attr_reader(:counter_date, :daily_counter)
  end

  class AttributeRanking < Attribute
    include UpdateableEach

    def initialize
      self.ranking_set = Set.new
    end

    def update_each(object=nil)
      ranking_set << object

      object
    end

    def has_ranking?
      !ranking_set.empty?
    end

    private

    attr_accessor(:ranking_set)
  end
end
