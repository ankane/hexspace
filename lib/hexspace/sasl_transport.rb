module Hexspace
  class SaslTransport < Thrift::FramedTransport
    attr_reader :options

    def initialize(transport, **options)
      super(transport)
      @options = options
    end

    def open
      super

      step = [options[:authzid], options[:username], options[:password]].map(&:to_s).join("\x00".b)

      write_sasl("\x01", "PLAIN")
      write_sasl("\x02", step)

      resp = @transport.read(5)
      case resp[0]
      when "\x03"
        len = resp[1..-1].unpack1("N")
        raise Error, @transport.read(len)
      when "\x05"
        # success
      else
        raise Error, "Unknown response: #{resp.inspect}"
      end
    end

    def write_sasl(status, body)
      @transport.write("#{status}#{[body.bytesize].pack("N")}#{body}")
      @transport.flush
    end
  end
end
