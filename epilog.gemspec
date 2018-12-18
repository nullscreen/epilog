# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'epilog/version'

Gem::Specification.new do |spec|
  spec.name = 'epilog'
  spec.version = Epilog::VERSION
  spec.authors = ['Justin Howard']
  spec.email = ['jmhoward0@gmail.com']
  spec.license = 'Apache-2.0'

  spec.summary = 'A JSON logger with Rails support'
  spec.homepage = 'https://github.com/machinima/epilog'

  spec.files = `git ls-files -z`
    .split("\x0")
    .reject { |f| f.match(%r{^spec/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'byebug', '~> 9.0'
  spec.add_development_dependency 'combustion', '~> 1.0.0'
  spec.add_development_dependency 'rails', '>= 4.2', '< 6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'redcarpet', '~> 3.4'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rspec-rails', '~> 3.8.1'
  spec.add_development_dependency 'rubocop', '~> 0.61'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'yard', '~> 0.9.11'
end
