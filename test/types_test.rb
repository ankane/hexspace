require_relative "test_helper"

class TypesTest < Minitest::Test
  def test_string
    assert_type "world", "SELECT 'world'"
  end

  def test_tinyint
    assert_type 1, "SELECT CAST(1 AS tinyint)"
  end

  def test_smallint
    assert_type 1, "SELECT CAST(1 AS smallint)"
  end

  def test_int
    assert_type 1, "SELECT 1"
    assert_type 1, "SELECT CAST(1 AS int)"
  end

  def test_bigint
    assert_type 1, "SELECT CAST(1 AS bigint)"
  end

  def test_decimal
    assert_type 1.5, "SELECT 1.5"
  end

  def test_double
    assert_type 1.5, "SELECT CAST(1.5 AS double)"
  end

  def test_float
    assert_type 1.5, "SELECT CAST(1.5 AS float)"
  end

  def test_boolean
    assert_type true, "SELECT true"
  end

  def test_date
    assert_type Date.today, "SELECT current_date()"
  end

  def test_timestamp
    assert_kind_of Time, client.execute("SELECT now() AS value").first["value"]
  end

  def assert_type(expected, expression)
    assert_equal expected, client.execute("#{expression} AS value").first["value"]
  end
end
