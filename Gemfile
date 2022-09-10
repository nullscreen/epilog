# frozen_string_literal: true

source 'https://rubygems.org'
gemspec

not_jruby = %i[ruby mingw x64_mingw].freeze
ruby_version = Gem::Version.new(RUBY_VERSION)
rails_version = Gem::Version.new(ENV.fetch('RAILS_VERSION', '5.2'))

gem 'byebug', platforms: not_jruby
gem 'rails', "~> #{rails_version}"
gem 'redcarpet', '~> 3.5', platforms: not_jruby
gem 'yard', '~> 0.9.25', platforms: not_jruby

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.6')
  gem 'rubocop', '~> 1.36.0'
  gem 'rubocop-rspec', '~> 2.12.0'
  gem 'simplecov', '>= 0.17.1'
  gem 'simplecov-cobertura', '~> 2.1'
end

if ruby_version >= Gem::Version.new('2.6')
  gem 'sqlite3', '~> 1.5'
else
  gem 'sqlite3', '~> 1.4', '< 1.5'
end
