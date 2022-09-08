# Epilog Gem

[![Gem Version](https://badge.fury.io/rb/epilog.svg)](https://badge.fury.io/rb/epilog)
[![Build Status](https://travis-ci.org/nullscreen/epilog.svg?branch=master)](https://travis-ci.org/nullscreen/epilog)
[![Code Climate](https://codeclimate.com/github/nullscreen/epilog/badges/gpa.svg)](https://codeclimate.com/github/nullscreen/epilog)
[![Test Coverage](https://codeclimate.com/github/nullscreen/epilog/badges/coverage.svg)](https://codeclimate.com/github/nullscreen/epilog)
[![Inline docs](http://inch-ci.org/github/nullscreen/epilog.svg?branch=master)](http://inch-ci.org/github/nullscreen/epilog)

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
