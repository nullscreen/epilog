# Epilog Gem

A JSON logger with Rails support.

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

Bug reports and pull requests are welcome on BitBucket at
https://bitbucket.com/machinima-dev/epilog.
