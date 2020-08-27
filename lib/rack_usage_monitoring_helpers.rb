  module RackUsageTrackingHelpers
  class HttpVersion
    attr_reader(:major, :minor)

    def initialize(http_version_string)
      major_minor_array = determine_major_minor(http_version_string)
      self.major = major_minor_array.first
      self.minor = major_minor_array.last
    end

    private

    def determine_major_minor(http_version_string)
      # 'HTTP/0.9' -> '0.9' => ['0', '9'] ==> [0, 9]
      major_dot_minor = http_version_string.split('/').last
      major_minor_as_string = major_dot_minor.split('.')
      major_minor_as_string.map(&:to_i)
    end

    attr_writer(:major, :minor)
  end

  class QueryParameter
    def initialize(key_value_string)
      if key_value_string.count('=') == 1
        self.key = key_value_string.split('=', 2).first
        self.value = key_value_string.split('=', 2).last
      else
        self.key = ''
        self.value = ''
      end
    end

    def self.parse_query_string(query_string)
      query_string = strip_leading_question_mark(query_string)
      query_string.split('&', -1)
    end

    def key
      @key
    end

    def value
      @value
    end

    private

    attr_writer(:key, :value)

    def self.strip_leading_question_mark(string)
      if string.start_with?('?')
        string[1..-1]
      else
        string
      end
    end
  end
end