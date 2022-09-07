# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'epilog/version'

Gem::Specification.new do |spec|
  spec.name = 'epilog'
  spec.version = Epilog::VERSION
  spec.authors = ['Justin Howard']
  spec.email = ['jmhoward0@gmail.com']
  spec.license = 'MIT'

  spec.summary = 'A JSON logger with Rails support'
  spec.homepage = 'https://github.com/nullscreen/epilog'

  spec.files = `git ls-files -z`
    .split("\x0")
    .reject { |f| f.match(%r{^spec/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1.12'
  spec.add_development_dependency 'byebug', '~> 11.0'
  spec.add_development_dependency 'combustion', '~> 1.3'
  spec.add_development_dependency 'irb'
  spec.add_development_dependency 'rails', '>= 4.2', '< 7'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'redcarpet', '~> 3.5'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rspec-rails', '~> 3.8.1'
  spec.add_development_dependency 'rubocop', '0.75'
  spec.add_development_dependency 'simplecov', '~> 0.17'
  spec.add_development_dependency 'sqlite3', '~> 1.3', '< 1.5'
  spec.add_development_dependency 'yard', '~> 0.9.11'
end
