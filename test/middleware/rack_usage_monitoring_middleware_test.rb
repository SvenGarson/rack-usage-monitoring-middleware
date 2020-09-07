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

  def test_that_RackUsageMonitoring_Middleware_responds_to_deployment?
    assert_equal(true, RackUsageMonitoring::Middleware.respond_to?(:deployment?))
  end

  def test_that_RackUsageMonitoring_Middleware_deployment_returns_true_when_app_runs_in_deployment_mode
    ENV[RackUsageMonitoring::Constants::KEY_RACK_ENV] = RackUsageMonitoring::Constants::RACK_ENV_DEPLOYMENT

    assert_equal(true, RackUsageMonitoring::Middleware.deployment?)
  end

  def test_that_RackUsageMonitoring_Middleware_deployment_returns_false_when_app_runs_in_development_mode
    ENV[RackUsageMonitoring::Constants::KEY_RACK_ENV] = RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT
    assert_equal(false, RackUsageMonitoring::Middleware.deployment?)
  end

  def test_that_RackUsageMonitoring_Middleware_deployment_returns_false_when_app_runs_in_none_mode
    ENV[RackUsageMonitoring::Constants::KEY_RACK_ENV] = RackUsageMonitoring::Constants::RACK_ENV_NONE
    assert_equal(false, RackUsageMonitoring::Middleware.deployment?)
  end
end