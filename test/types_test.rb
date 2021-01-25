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
    assert_type BigDecimal("1.5"), "SELECT 1.5"
  end

  def test_double
    assert_type 1.5, "SELECT CAST(1.5 AS double)"
  end

  def test_float
    assert_type 1.5, "SELECT CAST(1.5 AS float)"
    assert_type Float::INFINITY, "SELECT float('Infinity')"
    assert_type -Float::INFINITY, "SELECT float('-Infinity')"
    assert_type Float::NAN, "SELECT float('NaN')"
  end

  def test_boolean
    assert_type true, "SELECT true"
  end

  def test_date
    assert_type Date.today, "SELECT current_date()"
  end

  # TODO use Time
  def test_timestamp
    assert_kind_of String, client.execute("SELECT current_timestamp() AS value").first["value"]
  end

  # TODO typecast
  def test_array
    assert_type "[1,2,3]", "SELECT array(1, 2, 3)"
  end

  # TODO typecast
  def test_map
    assert_type '{1.5:"2",3.5:"4"}', "SELECT map(1.5, '2', 3.5, '4')"
  end

  def assert_type(expected, expression)
    result = client.execute("#{expression} AS value").first["value"]
    if expected.is_a?(Float) && expected.nan?
      assert result.nan?
    else
      assert_equal expected, result
    end
    assert_equal expected.class, result.class
  end
end
