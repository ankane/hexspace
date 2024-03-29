require_relative "test_helper"

class ClientTest < Minitest::Test
  def test_table
    client.execute("DROP TABLE IF EXISTS users")
    client.execute("CREATE TABLE users (id INT, name STRING)")
    client.execute("INSERT INTO users VALUES (1, 'Test 1'), (2, 'Test 2'), (3, 'Test 3')")

    expected = 1.upto(3).map { |i| {"id" => i, "name" => "Test #{i}"} }
    assert_equal expected, client.execute("SELECT * FROM users ORDER BY id")

    assert_equal 3, client.execute("SELECT COUNT(*) AS value FROM users").first["value"]

    result = client.execute("SELECT * FROM users ORDER BY id", result_object: true)
    assert_equal [[1, "Test 1"], [2, "Test 2"], [3, "Test 3"]], result.rows
    assert_equal ["id", "name"], result.columns
    assert_equal ["int", "string"], result.column_types
  end

  def test_show
    assert client.execute("SHOW DATABASES")
    assert client.execute("SHOW SCHEMAS")
    assert client.execute("SHOW TABLES")
  end

  def test_current_database
    assert_equal "hexspace_test", client.execute("SELECT current_database() AS value").first["value"]
  end

  def test_timeout
    error = assert_raises(Thrift::TransportException) do
      Hexspace::Client.new(host: "10.255.255.1", timeout: 0.1)
    end
    assert_equal "Could not connect to 10.255.255.1:10000: ", error.message
  end
end
