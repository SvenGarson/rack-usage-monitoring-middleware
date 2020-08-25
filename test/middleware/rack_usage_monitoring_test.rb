require_relative '../test_prerequisites'

=begin

  > things tested:
    - Classes/Modules are defined/exist
    - Classes inherit from other classes
    - Use namespaces!
    - objects responds to specific messages
    > method return:
        - values
        - type
        - range
    > when middleware preceed some other middle/-end ware
      - check that middleware propagates the call up the stack



  > to test
    - namespace RackUsageMonitoring
    > ::usage_data(env)
      - responds to
      - invoke with hash argument
      > return value:
        - if middleware #call(env) ed BEFORE
          => instance of UsageDataProtected
        - else (middleware NOT #call(env) ed before)
          => nil

=end

class RackUsageMonitoringTest < Minitest::Test
  def test_that_RackUsageMonitoring_accessible_when_middleware_required
    assert(defined?(RackUsageMonitoring))
  end

  def test_that_RackUsageMonitoring_Constants_accessible_when_middleware_required
    assert(defined?(RackUsageMonitoring::Constants))
  end

  def test_that_RackUsageMonitoring_UsageData_accessible_when_middleware_required
    assert(defined?(RackUsageMonitoring::UsageData))
  end

  def test_that_RackUsageMonitoring_UsageDataProtected_accessible_when_middleware_required
    assert(defined?(RackUsageMonitoring::UsageDataProtected))
  end

  def test_that_UsageDataProtected_is_subclass_of_UsageData
    assert_equal(true, RackUsageMonitoring::UsageDataProtected < RackUsageMonitoring::UsageData)
  end

  def test_that_RackUsageMonitoring_Middleware_accessible_when_middleware_required
    assert(defined?(RackUsageMonitoring::Middleware))
  end

  def test_that_RackUsageMonitoring_responds_to_usage_data
    assert_respond_to(RackUsageMonitoring, :usage_data)
  end

  def test_that_RackUsageMonitoring_usage_data_returns_nil_when_middleware_not_called_before
    data = Hash.new

    assert_nil(RackUsageMonitoring.usage_data(data))
  end

  def test_that_RackUsageMonitoring_usage_data_returns_UsageDataProtected_when_middleware_called_before
    env = Hash.new
    middleware = RackUsageMonitoring::Middleware.new
    middleware.call(env)

    usage_data_protected = RackUsageMonitoring.usage_data(env)

    refute_nil(usage_data_protected)
    #assert_instance_of(RackUsageMonitoring::UsageDataProtected)
  end
end