# Hexspace

Ruby client for Apache Spark SQL and Apache Hive

[![Build Status](https://github.com/ankane/hexspace/workflows/build/badge.svg?branch=master)](https://github.com/ankane/hexspace/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem "hexspace"
```

## Getting Started

Create a client

```ruby
client = Hexspace::Client.new
```

Execute queries

```ruby
client.execute("SELECT COUNT(*) FROM users")
```

## Connection Options

There are a number of connection options available.

```ruby
Hexspace::Client.new(
  host: "localhost",
  port: 10000,
  username: "user",
  password: "secret",
  database: "default",
  mode: :sasl,
  timeout: 10
)
```

Supported modes are `:sasl`, `:nosasl`, `:http`, and `:https`. Please create an issue if you need Kerberos.

The timeout is in seconds and only applies to `:sasl` and `:nosasl`.

## Query Options

Set a timeout

```ruby
client.execute(statement, timeout: 10)
```

Get a `Hexspace::Result` object instead of an array of hashes [unreleased]

```ruby
result = client.execute(statement, result_object: true)
result.rows
result.columns
result.column_types
result.to_a
```

## Spark SQL Setup

Download [Apache Spark](https://spark.apache.org/downloads.html) and start the [Thift server](https://spark.apache.org/docs/latest/sql-distributed-sql-engine.html).

```sh
./sbin/start-thriftserver.sh
```

## Hive Setup

Download [Apache Hive](https://hive.apache.org/downloads.html) and initialize the schema.

```sh
./bin/schematool -dbType derby -initSchema
```

Then start the [HiveServer2](https://cwiki.apache.org/confluence/display/Hive/Setting+Up+HiveServer2).

```sh
./bin/hiveserver2
```

It can take a minute or two to be ready. To debug, pass `--hiveconf hive.root.logger=DEBUG,console`.

## History

View the [changelog](https://github.com/ankane/hexspace/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/hexspace/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/hexspace/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/hexspace.git
cd hexspace
bundle install

# create a database
beeline -u jdbc:hive2://localhost:10000 -e 'CREATE DATABASE hexspace_test;'

# run the tests
bundle exec rake test
```

Resources

- [Spark SQL Reference](https://spark.apache.org/docs/latest/sql-ref.html)
- [Hive Language Manual](https://cwiki.apache.org/confluence/display/Hive/LanguageManual)
- [Thrift SASL Spec](https://github.com/apache/thrift/blob/master/doc/specs/thrift-sasl-spec.txt)
