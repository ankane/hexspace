require_relative "lib/hexspace/version"

Gem::Specification.new do |spec|
  spec.name          = "hexspace"
  spec.version       = Hexspace::VERSION
  spec.summary       = "Ruby client for Apache Spark SQL and Apache Hive"
  spec.homepage      = "https://github.com/ankane/hexspace"
  spec.license       = "Apache-2.0"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 3"

  spec.add_dependency "bigdecimal"
  spec.add_dependency "thrift", ">= 0.18"
end
