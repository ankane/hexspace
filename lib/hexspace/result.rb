module Hexspace
  class Result
    attr_reader :rows, :columns, :column_types

    def initialize(rows, columns, column_types)
      @rows = rows
      @columns = columns
      @column_types = column_types
    end

    def to_a
      @rows.map do |row|
        @columns.zip(row).to_h
      end
    end
  end
end
