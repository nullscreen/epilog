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

  rubydoc = 'https://www.rubydoc.info/gems'
  spec.metadata = {
    'changelog_uri' => "#{spec.homepage}/blob/main/CHANGELOG.md",
    'documentation_uri' => "#{rubydoc}/#{spec.name}/#{spec.version}",
    'rubygems_mfa_required' => 'true'
  }

  spec.files = Dir['lib/**/*.rb', '*.md', '*.txt', '.yardopts']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'

  spec.add_development_dependency 'combustion', '~> 1.3'
  spec.add_development_dependency 'rails', '>= 4.2', '< 8'
  spec.add_development_dependency 'rspec', '~> 3.11'
  spec.add_development_dependency 'rspec-rails', '>= 5.1'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
end
