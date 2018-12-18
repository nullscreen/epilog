# Epilog Gem

[![Gem Version](https://badge.fury.io/rb/epilog.svg)](https://badge.fury.io/rb/epilog)
[![Build Status](https://travis-ci.org/machinima/epilog.svg?branch=master)](https://travis-ci.org/machinima/epilog)
[![Code Climate](https://codeclimate.com/github/machinima/epilog/badges/gpa.svg)](https://codeclimate.com/github/machinima/epilog)
[![Test Coverage](https://codeclimate.com/github/machinima/epilog/badges/coverage.svg)](https://codeclimate.com/github/machinima/epilog)
[![Inline docs](http://inch-ci.org/github/machinima/epilog.svg?branch=master)](http://inch-ci.org/github/machinima/epilog)

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

Bug reports and pull requests are welcome on GitHub at
https://github.com/machinima/epilog.

## License

Copyright 2018 Warner Bros. Entertainment Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
