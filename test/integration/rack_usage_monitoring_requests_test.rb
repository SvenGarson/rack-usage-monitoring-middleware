require_relative '../test_prerequisites'


class RackUsageMonitoringRequestsTest < Minitest::Test
  def test_that_something_when_something
    # middleware wrapper in order to acceess usage data protected
    middleware_wrapper = middleware_usage_data_protected_access_wrapper

    # mock request to the middleware where the responds is the one from DummyEndware
    mock_request = Rack::MockRequest.new(middleware_wrapper)

    # make all requests to mock_request - disregard the endware response
    mock_request.get('http://www.meep.com/books?name=MobyDick')

    # get a hold of the usage data protected from the middleware env hash
    

    # get a hold of the tracker to test

    # assert tracker data
  end

  private

  class DummyEndware
    def call(env)
      Rack::Response.new.finish
    end
  end

  class RackUsageMonitoringWrapper
    attr_reader(:usage_data_protected)

    def initialize(endware)
      self.usage_monitoring_middleware = RackUsageMonitoring::Middleware.new(endware)
    end

    def call(env)
      # #call(env) rack usage middleware which has the following effects:
      # 1. rack usage middleware tracks data and adds usage data objects to env hash
      # 2. rack usage middleware propagates #call(env) to endware
      # 3. rack usage middleware returns the response returned from endware#call
      endware_response = usage_monitoring_middleware.call(env)

      # get a hold of the usage data through the wrapper
      self.usage_data_protected = RackUsageMonitoring::usage_data(env)

      # return the endware response
      endware_response
    end

    private

    attr_writer(:usage_data_protected)
    attr_accessor(:usage_monitoring_middleware)
  end

  def middleware_usage_data_protected_access_wrapper
    endware = DummyEndware.new
    RackUsageMonitoringWrapper.new(endware)
  end
end

=begin

  How to begin the testing for the middleware integration:
  - setup stack
  - make requests with needed data points
  - get a hold of the UsageDataProtected
  - get the tracker to be tested
  > assert against tracker instance
    - correct object (instance of) # also makes sure the tracker specific tests are in place
    - correct returns data for each tracker attribute


  # 1. middleware: update trackers and generate UsageDataProtected + add into env hash
  # 2. wrapper   : get a hold of UsageDataProtected through env hash and make available through method
  # 3. endware   : generate base response so Rack runs properly
  # 4. get UageDataProtected and assert against it


  Requests tests to run
    - correct tracker instance
    - #count as expected / starts at zero
    - #today as expected / starts at zero
=end