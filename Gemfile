# frozen_string_literal: true

source 'https://rubygems.org'
gemspec

not_jruby = %i[ruby mingw x64_mingw].freeze
rails_version = Gem::Version.new(ENV.fetch('RAILS_VERSION', '7.1.0'))

gem 'byebug', platforms: not_jruby
gem 'rails', "~> #{rails_version}"
gem 'redcarpet', '~> 3.5', platforms: not_jruby
gem 'rubocop', '~> 1.36.0'
gem 'rubocop-rspec', '~> 2.12.0'
gem 'simplecov', '>= 0.17.1'
gem 'simplecov-cobertura', '~> 2.1'
gem 'yard', '~> 0.9.25', platforms: not_jruby

# Rails 7.0's ActiveRecord adapter requires sqlite3 ~> 1.4; 7.1+ allows 2.x
gem 'sqlite3', rails_version < Gem::Version.new('7.1') ? '~> 1.4' : '>= 1.4'
