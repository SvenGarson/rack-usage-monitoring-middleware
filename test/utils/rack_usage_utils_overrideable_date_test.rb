require_relative '../test_prerequisites'

class RackUsageUtilsOverrideableDateTest < Minitest::Test
  def test_that_OverrideableDate_accessible_when_middleware_required
    assert(defined?(RackUsageUtils::OverrideableDate))
  end

  def test_that_OverrideableDate_responds_to_set_today_date
    assert_equal(true, RackUsageUtils::OverrideableDate.respond_to?(:set_today_date))
  end

  def test_that_OverrideableDate_set_today_date_returns_original_argument
    argument_date = Date.today
    assert_same(argument_date, RackUsageUtils::OverrideableDate.set_today_date(argument_date))
  end

  def test_that_OverrideableDate_responds_to_today
    assert_equal(true, RackUsageUtils::OverrideableDate.respond_to?(:today))
  end

  def test_that_OverrideableDate_today_returns_some_date_when_date_has_not_yet_overriden_in_development_mode
    set_development_mode

    assert_instance_of(Date, RackUsageUtils::OverrideableDate.today)
  end

  def test_that_OverrideableDate_today_returns_some_date_when_date_has_not_yet_overriden_in_none_mode
    set_none_mode

    assert_instance_of(Date, RackUsageUtils::OverrideableDate.today)
  end

  def test_that_OverrideableDate_today_returns_some_date_when_date_has_not_yet_overriden_in_deployment_mode
    set_deployment_mode

    assert_instance_of(Date, RackUsageUtils::OverrideableDate.today)
  end

  # test that today returns the overriden dupped date when date was overriden AND app is in NONE mode
  # test that today returns the overriden dupped date when date was overriden AND app is in DEV  mode
  # test that set date is ignored, i.e. not returned by today if app is in DEPLOY mode

  private

  def set_development_mode
    ENV[RackUsageMonitoring::Constants::KEY_RACK_ENV] = RackUsageMonitoring::Constants::RACK_ENV_DEVELOPMENT
  end

  def set_none_mode
    ENV[RackUsageMonitoring::Constants::KEY_RACK_ENV] = RackUsageMonitoring::Constants::RACK_ENV_NONE
  end

  def set_deployment_mode
    ENV[RackUsageMonitoring::Constants::KEY_RACK_ENV] = RackUsageMonitoring::Constants::RACK_ENV_DEPLOYMENT
  end
end

=begin
  Test the following:
    > today:
      - returns samedate when none or development
      - returns Date.today when deployment + ignores set date (unless today is the same date)

=end