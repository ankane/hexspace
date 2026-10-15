module Hexspace
  class Result
    include Enumerable

    attr_reader :rows, :columns, :column_types

    def initialize(rows, columns, column_types)
      @rows = rows
      @columns = columns
      @column_types = column_types
    end

    def each
      @rows.each do |row|
        yield @columns.zip(row).to_h
      end
    end
  end
end
