  module RackUsageTrackingHelpers
  class HttpVersion
    attr_reader(:major, :minor)

    def initialize(http_version_string)
      major_minor_array = determine_major_minor(http_version_string)
      self.major = major_minor_array.first
      self.minor = major_minor_array.last
    end

    def <=>(other)
      return nil unless other.instance_of?(self.class)

      self_version_sum = unique_major_minor_sum
      other_version_sum = other.unique_major_minor_sum

      if self_version_sum < other_version_sum
        -1
      elsif self_version_sum > other_version_sum
        1
      else
        0
      end
    end

    def hash
      unique_major_minor_sum
    end

    def eql?(other)
      hash == other.hash
    end

    def ==(other)
      eql?(other)
    end

    private

    def determine_major_minor(http_version_string)
      # 'HTTP/0.9' -> '0.9' => ['0', '9'] ==> [0, 9]
      major_dot_minor = http_version_string.split('/').last
      major_minor_as_string = major_dot_minor.split('.')
      major_minor_as_string.map(&:to_i)
    end

    attr_writer(:major, :minor)

    protected

    def unique_major_minor_sum
      (major * 10) + minor
    end
  end

  class QueryParameter

    def initialize(key_value_string)
      parameter_key, parameter_value = determine_key_and_value(key_value_string)

      self.key = parameter_key
      self.value = parameter_value
    end

    def self.parse_query_string(query_string)
      query_string = strip_leading_question_mark(query_string)
      query_string.split('&', -1).map do |key_value_string|
        self.new(key_value_string)
      end
    end

    def key
      @key.dup
    end

    def value
      @value.dup
    end

    def hash
      to_s.hash
    end

    def eql?(other)
      to_s == other.to_s
    end

    def ==(other)
      eql?(other)
    end

    def to_s
      key + '=' + value
    end

    private

    attr_writer(:key, :value)

    def determine_key_and_value(key_value_string)
      if key_value_string.count('=') == 1
        key_value_string.split('=', 2)
      else
        ['', '']
      end
    end

    def self.strip_leading_question_mark(string)
      if string.start_with?('?')
        string[1..-1]
      else
        string
      end
    end
  end
end