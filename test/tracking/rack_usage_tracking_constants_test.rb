require_relative '../test_prerequisites'

class RackUsageTrackingConstantsTest < Minitest::Test
  def test_that_RackUsageTracking_Constants_accessible_when_middleware_required
    assert(defined?(RackUsageTracking::Constants))
  end

  def test_that_RackUsageTracking_Constants_is_frozen
    assert_equal(true, RackUsageTracking::Constants.frozen?)
  end

  def test_that_RackUsageTracking_Constants_contains_KEY_PATH_INFO
    assert(defined?(RackUsageTracking::Constants::KEY_PATH_INFO))
  end

  def test_that_RackUsageTracking_Constants_KEY_PATH_INFO_is_a_string
    assert_instance_of(String, RackUsageTracking::Constants::KEY_PATH_INFO)
  end

  def test_that_RackUsageTracking_Constants_KEY_PATH_INFO_has_the_correct_string_value
    assert_equal('PATH_INFO', RackUsageTracking::Constants::KEY_PATH_INFO)    
  end

  def test_that_RackUsageTracking_Constants_contains_KEY_REQUEST_URI
    assert(defined?(RackUsageTracking::Constants::KEY_REQUEST_URI))
  end

  def test_that_RackUsageTracking_Constants_KEY_REQUEST_URI_is_a_string
    assert_instance_of(String, RackUsageTracking::Constants::KEY_REQUEST_URI)
  end

  def test_that_RackUsageTracking_Constants_KEY_REQUEST_URI_has_the_correct_string_value
    assert_equal('REQUEST_URI', RackUsageTracking::Constants::KEY_REQUEST_URI)    
  end

  def test_that_RackUsageTracking_Constants_contains_KEY_HTTP_ACCEPT
    assert(defined?(RackUsageTracking::Constants::KEY_HTTP_ACCEPT))
  end

  def test_that_RackUsageTracking_Constants_KEY_HTTP_ACCEPT_is_a_string
    assert_instance_of(String, RackUsageTracking::Constants::KEY_HTTP_ACCEPT)
  end

  def test_that_RackUsageTracking_Constants_KEY_HTTP_ACCEPT_has_the_correct_string_value
    assert_equal('HTTP_ACCEPT', RackUsageTracking::Constants::KEY_HTTP_ACCEPT)    
  end

  def test_that_RackUsageTracking_Constants_contains_KEY_HTTP_VERSION
    assert(defined?(RackUsageTracking::Constants::KEY_HTTP_VERSION))
  end

  def test_that_RackUsageTracking_Constants_KEY_HTTP_VERSION_is_a_string
    assert_instance_of(String, RackUsageTracking::Constants::KEY_HTTP_VERSION)
  end

  def test_that_RackUsageTracking_Constants_KEY_HTTP_VERSION_has_the_correct_string_value
    assert_equal('HTTP_VERSION', RackUsageTracking::Constants::KEY_HTTP_VERSION)    
  end

  def test_that_RackUsageTracking_Constants_contains_KEY_QUERY_STRING
    assert(defined?(RackUsageTracking::Constants::KEY_QUERY_STRING))
  end

  def test_that_RackUsageTracking_Constants_KEY_QUERY_STRING_is_a_string
    assert_instance_of(String, RackUsageTracking::Constants::KEY_QUERY_STRING)
  end

  def test_that_RackUsageTracking_Constants_KEY_QUERY_STRING_has_the_correct_string_value
    assert_equal('QUERY_STRING', RackUsageTracking::Constants::KEY_QUERY_STRING)    
  end

  def test_that_RackUsageTracking_Constants_contains_KEY_REQUEST_METHOD
    assert(defined?(RackUsageTracking::Constants::KEY_REQUEST_METHOD))
  end

  def test_that_RackUsageTracking_Constants_KEY_REQUEST_METHOD_is_a_string
    assert_instance_of(String, RackUsageTracking::Constants::KEY_REQUEST_METHOD)
  end

  def test_that_RackUsageTracking_Constants_KEY_REQUEST_METHOD_has_the_correct_string_value
    assert_equal('REQUEST_METHOD', RackUsageTracking::Constants::KEY_REQUEST_METHOD)    
  end

  def test_that_RackUsageTracking_Constants_contains_KEY_ACCEPT_LANGUAGE
    assert(defined?(RackUsageTracking::Constants::KEY_ACCEPT_LANGUAGE))
  end

  def test_that_RackUsageTracking_Constants_KEY_ACCEPT_LANGUAGE_is_a_string
    assert_instance_of(String, RackUsageTracking::Constants::KEY_ACCEPT_LANGUAGE)
  end

  def test_that_RackUsageTracking_Constants_KEY_ACCEPT_LANGUAGE_has_the_correct_string_value
    assert_equal('HTTP_ACCEPT_LANGUAGE', RackUsageTracking::Constants::KEY_ACCEPT_LANGUAGE)    
  end

  def test_that_RackUsageTracking_Constants_contains_KEY_ACCEPT_ENCODING
    assert(defined?(RackUsageTracking::Constants::KEY_ACCEPT_ENCODING))
  end

  def test_that_RackUsageTracking_Constants_KEY_ACCEPT_ENCODING_is_a_string
    assert_instance_of(String, RackUsageTracking::Constants::KEY_ACCEPT_ENCODING)
  end

  def test_that_RackUsageTracking_Constants_KEY_ACCEPT_ENCODING_has_the_correct_string_value
    assert_equal('HTTP_ACCEPT_ENCODING', RackUsageTracking::Constants::KEY_ACCEPT_ENCODING)    
  end
end