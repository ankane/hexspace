# dependencies
require "thrift"

# stdlib
require "bigdecimal"
require "time"

# thrift
require "hexspace/tcli_service_constants"
require "hexspace/tcli_service_types"
require "hexspace/tcli_service"

# modules
require "hexspace/client"
require "hexspace/sasl_transport"
require "hexspace/version"

module Hexspace
  class Error < StandardError; end
end
