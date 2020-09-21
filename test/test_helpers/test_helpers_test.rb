require_relative '../test_prerequisites'
require_relative '../test_helpers'

class TestHelpersTest < Minitest::Test
  def test_that_HashDataPoints_double_equals_returns_false_when_hash_object_ids_differ
    a = Hash.new
    b = Hash.new

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(false, hashes_identical)
  end

  def test_that_HashDataPoints_double_equals_returns_true_when_hash_object_ids_identical
    a = Hash.new
    b = a

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(true, hashes_identical)
  end

  def test_that_HashDataPoints_double_equals_returns_false_when_hash_sizes_differ
    a = {a: 65}
    b = {a: 65, b: 66}

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(false, hashes_identical)
  end

  def test_that_HashDataPoints_double_equals_returns_false_when_hash_keys_values_differ
    a = {'foo' => 'bar'}
    b = {'zoo' => 'bar'}

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(false, hashes_identical)
  end

  def test_that_HashDataPoints_double_equals_returns_false_when_hash_values_values_differ
    a = {'foo' => 'bar'}
    b = {'foo' => 'far'}

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(false, hashes_identical)
  end

  def test_that_HashDataPoints_double_equals_returns_false_when_hash_keys_object_ids_differ
    a = {'name' => 'Thor'}
    b = {'name' => 'Thor'}

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(false, hashes_identical)
  end

  def test_that_HashDataPoints_double_equals_returns_false_when_hash_values_object_ids_differ
    a = {'name' => 'Thor'}
    b = {'name' => 'Thor'}

    hash_data_points_a = Helpers::HashDataPoints.new(a)
    hash_data_points_b = Helpers::HashDataPoints.new(b)
    hashes_identical = (hash_data_points_a == hash_data_points_b)

    assert_equal(false, hashes_identical)
  end
end