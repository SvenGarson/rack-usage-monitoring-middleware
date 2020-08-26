require_relative '../test_prerequisites'
require_relative '../test_helpers'

class RackUsageMonitoringMiddlewareTest < Minitest::Test
  def test_that_RackUsageMonitoring_Middleware_accessible_when_middleware_required
    assert(defined?(RackUsageMonitoring::Middleware))
  end

  def test_that_RackUsageMonitoring_Middleware_responds_to_call
    assert_equal(true, RackUsageMonitoring::Middleware.new(Object.new).respond_to?(:call))
  end

  def test_that_RackUsageMonitoring_Middleware_new_takes_single_argument
    assert_instance_of(RackUsageMonitoring::Middleware, RackUsageMonitoring::Middleware.new(Object.new))
  end

  def test_that_RackUsageMonitoring_Middleware_call_adds_UsageDataProtected_to_env
    env = Hash.new
    middleware = RackUsageMonitoring::Middleware.new(Helpers.endware_that_responds_to_call)

    middleware.call(env)

    assert_equal(1, env.size)
    assert_includes(env, RackUsageMonitoring::Constants::KEY_USAGE_DATA_PROTECTED)
    assert_instance_of(RackUsageMonitoring::UsageDataProtected,
                       env[RackUsageMonitoring::Constants::KEY_USAGE_DATA_PROTECTED])
  end

  def test_that_RackUsageMonitoring_Middleware_call_returns_superseeding_rack_application_response
    env = Hash.new
    superseeding_rack_application = Helpers.endware_that_returns_random_uuid_on_call
    middleware = RackUsageMonitoring::Middleware.new(superseeding_rack_application)

    middleware_return_value = middleware.call(env)
    assert_equal(superseeding_rack_application.uuid, middleware_return_value)
  end
end