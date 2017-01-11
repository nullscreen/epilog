# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'epilog/version'

Gem::Specification.new do |spec|
  spec.name = 'epilog'
  spec.version = Epilog::VERSION
  spec.authors = ['Justin Howard']
  spec.email = ['jmhoward0@gmail.com']

  spec.summary = 'Description goes here'
  spec.homepage = 'https://github.com/justinhoward/epilog'

  spec.files = `git ls-files -z`
    .split("\x0")
    .reject { |f| f.match(%r{^spec/}) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'byebug', '~> 9.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.40'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'yard', '~> 0.9'
  spec.add_development_dependency 'rails', '~> 4.2'
  spec.add_development_dependency 'rspec-rails', '~> 3.5'
  spec.add_development_dependency 'timecop', '~> 0.8'
  spec.add_development_dependency 'combustion', '~> 0.5.5'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
end
