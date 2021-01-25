require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

class Minitest::Test
  def client
    @client ||= Hexspace::Client.new(
      mode: (ENV["HEXSPACE_MODE"] || :sasl).to_sym,
      database: "hexspace_test"
    )
  end
end
