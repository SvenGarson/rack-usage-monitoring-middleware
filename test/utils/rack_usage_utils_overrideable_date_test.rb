require_relative '../test_prerequisites'

class RackUsageUtilsOverrideableDateTest < Minitest::Test
  def test_that_OverrideableDate_accessible_when_middleware_required
    assert(defined?(RackUsageUtils::OverrideableDate))
  end

  def test_that_OverrideableDate_responds_to_set_today_date
    assert_equal(true, RackUsageUtils::OverrideableDate.respond_to?(:set_today_date))
  end

  def test_that_OverrideableDate_set_today_date_returns_original_argument
    argument_date = random_date
    assert_same(argument_date, RackUsageUtils::OverrideableDate.set_today_date(argument_date))
  end

  def test_that_OverrideableDate_responds_to_today
    assert_equal(true, RackUsageUtils::OverrideableDate.respond_to?(:today))
  end

  def test_that_OverrideableDate_today_returns_some_date_when_date_has_not_yet_been_set_in_development_mode
    set_development_mode

    assert_instance_of(Date, RackUsageUtils::OverrideableDate.today)
  end

  def test_that_OverrideableDate_today_returns_some_date_when_date_has_not_yet_been_set_in_none_mode
    set_none_mode

    assert_instance_of(Date, RackUsageUtils::OverrideableDate.today)
  end

  def test_that_OverrideableDate_today_returns_some_date_when_date_has_not_yet_been_set_in_deployment_mode
    set_deployment_mode

    assert_instance_of(Date, RackUsageUtils::OverrideableDate.today)
  end

  def test_that_OverrideableDate_today_returns_set_date_when_date_has_been_set_in_none_mode
    set_none_mode

    400.times do |_|
      date_set = random_date
      RackUsageUtils::OverrideableDate.set_today_date(date_set)

      date_today = RackUsageUtils::OverrideableDate.today

      assert_equal(date_set, date_today)
    end
  end

  def test_that_OverrideableDate_today_returns_set_date_when_date_has_been_set_in_development_mode
    set_development_mode

    400.times do |_|
      date_set = random_date
      RackUsageUtils::OverrideableDate.set_today_date(date_set)

      date_today = RackUsageUtils::OverrideableDate.today

      assert_equal(date_set, date_today)
    end
  end

  def test_that_OverrideableDate_today_does_not_return_set_date_when_date_has_been_set_in_deployment_mode
    set_deployment_mode

    400.times do |_|
      date_set = random_date

      # test next random date if today is the same date as the random date
      # because we cannot detect whether the set date or Date::today is returned
      next if utc_date == date_set

      RackUsageUtils::OverrideableDate.set_today_date(date_set)

      date_today = RackUsageUtils::OverrideableDate.today

      refute_equal(date_set, date_today)
    end
  end

  private

  def utc_date
    Time.now.utc.to_date
  end

  def random_date
    Time.at(rand * Time.now.utc.to_i).to_date
  end

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
