# dependencies
require "thrift"

# stdlib
require "bigdecimal"
require "time"

# thrift
require_relative "hexspace/tcli_service_constants"
require_relative "hexspace/tcli_service_types"
require_relative "hexspace/tcli_service"

# modules
require_relative "hexspace/client"
require_relative "hexspace/result"
require_relative "hexspace/sasl_transport"
require_relative "hexspace/version"

module Hexspace
  class Error < StandardError; end
end
