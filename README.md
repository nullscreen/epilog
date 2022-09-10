# Epilog Gem

[![Gem Version](https://badge.fury.io/rb/epilog.svg)](https://badge.fury.io/rb/epilog)
[![CI](https://github.com/nullscreen/epilog/workflows/CI/badge.svg)](https://github.com/nullscreen/epilog/actions?query=workflow%3ACI+branch%main)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/28734dd732d34bc3b014760508b2d3da)](https://www.codacy.com/gh/nullscreen/epilog/dashboard)
[![Code Coverage](https://codecov.io/gh/nullscreen/epilog/branch/main/graph/badge.svg?token=3Q3M49C5ZI)](https://codecov.io/gh/nullscreen/epilog)

A JSON logger with Rails support.

## Documentation

Read below to get started, or see the [API Documentation][api-docs] for more
details.

[api-docs]: https://www.rubydoc.info/github/nullscreen/epilog

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'epilog'
```

## Basic Usage

This logger is compatible with the native Ruby Logger interface. To use it, just
create an instance of `Epilog::Logger`.

```ruby
logger = Epilog::Logger.new($stdout)
```

## Rails Support

To use Epilog with Rails, simply override the Rails default logger with an
Epilog logger. Do this in your `application.rb` or `<environment>.rb`.

```ruby
config.logger = Epilog::Logger.new($stdout)
config.logger.progname = 'epilog'
config.log_level = :debug
```

## Development

You can run `bin/console` for an interactive prompt that will allow you to
experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/nullscreen/epilog.
