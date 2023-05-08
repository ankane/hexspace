module Hexspace
  class Client
    attr_reader :client, :transport, :session

    def initialize(host: "localhost", port: nil, username: nil, password: nil, database: nil, mode: :sasl, timeout: nil)
      # could use current user in the future (like beeline)
      username ||= "anonymous"
      password ||= "anonymous"

      # TODO support kerberos
      # TODO support ssl for sockets
      @transport =
        case mode
        when :sasl
          socket = Thrift::Socket.new(host, port || 10000, timeout)
          # TODO support authzid
          SaslTransport.new(socket, username: username, password: password)
        when :nosasl
          socket = Thrift::Socket.new(host, port || 10000, timeout)
          Thrift::BufferedTransport.new(socket)
        when :http, :https
          raise ArgumentError, "timeout not supported with #{mode}" if timeout

          uri_class = mode == :http ? URI::HTTP : URI::HTTPS
          uri = uri_class.build(host: host, port: port || 10001, path: "/cliservice")

          t = Thrift::HTTPClientTransport.new(uri)
          t.add_headers({"Authorization" => "Basic #{Base64.strict_encode64("#{username}:#{password}")}"})
          t
        else
          raise ArgumentError, "Invalid mode: #{mode}"
        end
      @transport.open

      protocol = Thrift::BinaryProtocol.new(@transport)
      @client = TCLIService::Client.new(protocol)

      req = TOpenSessionReq.new
      configuration = {
        # remove table prefix with Hive
        "set:hiveconf:hive.resultset.use.unique.column.names" => "false"
      }
      configuration["use:database"] = database if database
      req.configuration = configuration
      @session = @client.OpenSession(req)
      check_status @session

      ObjectSpace.define_finalizer(self, self.class.finalize(@transport, @client, @session))
    end

    # TODO add new method that returns Result object
    # so its possible to get duplicate columns
    # as well as columns when there are no rows
    def execute(statement, timeout: nil)
      result = execute_statement(statement, timeout: timeout)
      process_result(result) if result.operationHandle.hasResultSet
    end

    # private
    def self.finalize(transport, client, session)
      proc do
        req = TCloseSessionReq.new
        req.sessionHandle = session.sessionHandle
        client.CloseSession(req)
        transport.close
      end
    end

    private

    def check_status(obj)
      if obj.status.statusCode != TStatusCode::SUCCESS_STATUS
        raise Error, obj.status.errorMessage
      end
    end

    def execute_statement(statement, async: false, timeout: nil)
      req = TExecuteStatementReq.new
      req.sessionHandle = session.sessionHandle
      req.statement = statement
      req.runAsync = async
      req.queryTimeout = timeout if timeout
      result = client.ExecuteStatement(req)
      check_status result
      result
    end

    def process_result(stmt)
      req = TGetResultSetMetadataReq.new
      req.operationHandle = stmt.operationHandle
      metadata = client.GetResultSetMetadata(req)
      check_status metadata

      rows = []
      columns = metadata.schema.columns.map(&:columnName)
      types = metadata.schema.columns.map { |c| TYPE_NAMES[c.typeDesc.types.first.primitiveEntry.type].downcase }

      loop do
        req = TFetchResultsReq.new
        req.operationHandle = stmt.operationHandle
        req.maxRows = 10_000
        result = client.FetchResults(req)
        check_status result

        new_rows = 0
        start_offset = result.results.startRowOffset

        # columns can be nil with Spark 3.4+
        result.results.columns&.each_with_index do |col, j|
          name = columns[j]
          value = col.get_value

          if j == 0
            new_rows = value.values.size
            new_rows.times do
              rows << {}
            end
          end

          offset = start_offset
          nulls = value.nulls.unpack1("b*")
          values = value.values

          case types[j]
          # TODO decide how to handle time zones
          # when "timestamp"
          #   values.each do |v|
          #     rows[offset][name] = nulls[offset] == "1" ? nil : Time.parse(v)
          #     offset += 1
          #   end
          when "date"
            values.each do |v|
              rows[offset][name] = nulls[offset] == "1" ? nil : Date.parse(v)
              offset += 1
            end
          when "decimal"
            values.each do |v|
              rows[offset][name] = nulls[offset] == "1" ? nil : BigDecimal(v)
              offset += 1
            end
          else
            values.each do |v|
              rows[offset][name] = nulls[offset] == "1" ? nil : v
              offset += 1
            end
          end
        end

        break if new_rows < req.maxRows && !result.hasMoreRows
      end

      req = TCloseOperationReq.new
      req.operationHandle = stmt.operationHandle
      check_status client.CloseOperation(req)

      rows
    end
  end
end
