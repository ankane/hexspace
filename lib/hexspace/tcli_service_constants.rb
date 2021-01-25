#
# Autogenerated by Thrift Compiler (0.13.0)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#


module Hexspace
  PRIMITIVE_TYPES = Set.new([
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
  ])

  COMPLEX_TYPES = Set.new([
        10,
        11,
        12,
        13,
        14,
  ])

  COLLECTION_TYPES = Set.new([
        10,
        11,
  ])

  TYPE_NAMES = {
        10 => %q"ARRAY",
        4 => %q"BIGINT",
        9 => %q"BINARY",
        0 => %q"BOOLEAN",
        19 => %q"CHAR",
        17 => %q"DATE",
        15 => %q"DECIMAL",
        6 => %q"DOUBLE",
        5 => %q"FLOAT",
        21 => %q"INTERVAL_DAY_TIME",
        20 => %q"INTERVAL_YEAR_MONTH",
        3 => %q"INT",
        11 => %q"MAP",
        16 => %q"NULL",
        2 => %q"SMALLINT",
        7 => %q"STRING",
        12 => %q"STRUCT",
        8 => %q"TIMESTAMP",
        1 => %q"TINYINT",
        13 => %q"UNIONTYPE",
        18 => %q"VARCHAR",
  }

  CHARACTER_MAXIMUM_LENGTH = %q"characterMaximumLength"

  PRECISION = %q"precision"

  SCALE = %q"scale"

end
