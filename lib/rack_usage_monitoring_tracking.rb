require_relative 'rack_usage_monitoring_attributes'

module RackUsageTracking
  module Constants
    KEY_PATH_INFO = 'PATH_INFO'
    KEY_REQUEST_URI = 'REQUEST_URI'
    KEY_HTTP_ACCEPT = 'HTTP_ACCEPT'
    KEY_HTTP_VERSION = 'HTTP_VERSION'
    KEY_QUERY_STRING = 'QUERY_STRING'
    KEY_REQUEST_METHOD = 'REQUEST_METHOD'
    KEY_ACCEPT_LANGUAGE = 'HTTP_ACCEPT_LANGUAGE'
    KEY_ACCEPT_ENCODING = 'HTTP_ACCEPT_ENCODING'
  end

  Constants.freeze

  class Tracker
    def requirements_met?(env)
      false
    end
  end

  class TrackerRequest; end
  class TrackerHttpMethod; end
  class TrackerAcceptedLanguage; end
  class TrackerAcceptedEncoding; end
  class TrackerPath; end
  class TrackerQueryString; end
  class TrackerRoute; end
  class TrackerHttpVersion; end
  class TrackerQueryParameter; end
end