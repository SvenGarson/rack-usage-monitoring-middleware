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

    def lowest
      ranking_set.min.dup
    end

    def highest
      ranking_set.max.dup
    end

    def all
      ranking_set.to_a.map(&:dup)
    end

    private

    attr_accessor(:ranking_set)
  end

  class AttributeNumberAverage < Attribute
    include UpdateableEach

    def initialize
      self.running_sum = 0.0
      self.running_count = 0
    end

    def update_each(object=nil)
      self.running_count += 1
      self.running_sum += object.to_f
    end

    def average
      if running_count == 0
        0.0
      else
        running_sum / running_count.to_f
      end
    end

    private

    attr_accessor(:running_sum, :running_count)
  end

  class AttributeFrequency < Attribute
    include UpdateableEach

    def initialize
      @object_count_hash = Hash.new
    end

    def update_each(object=nil)
      if @object_count_hash.has_key?(object)
        @object_count_hash[object] += 1
      else
        @object_count_hash[object] = 1
      end

      object
    end

    def least_frequent
      lowest_frequency = @object_count_hash.values.min

      lowest_frequency_objects_as_hash = @object_count_hash.select do |_, count|
        count == lowest_frequency
      end

      lowest_frequency_objects_as_hash.keys.map(&:dup)
    end

    def most_frequent
      highest_frequency = @object_count_hash.values.max

      highest_frequency_objects_as_hash = @object_count_hash.select do |_, count|
        count == highest_frequency
      end

      highest_frequency_objects_as_hash.keys.map(&:dup)
    end

    def all
      @object_count_hash.keys.map(&:dup)
    end
  end

  class AttributeStringLength < Attribute
    include UpdateableEach

    def update_each(object=nil)
      object
    end

    def has_shortest?
      false
    end
  end
end
