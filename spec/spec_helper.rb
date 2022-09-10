# frozen_string_literal: true

require 'byebug' if Gem.loaded_specs['byebug']

if Gem.loaded_specs['simplecov'] && (ENV.fetch('COVERAGE', nil) || ENV.fetch('CI', nil))
  require 'simplecov'
  if ENV['CI']
    require 'simplecov-cobertura'
    SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
  end

  SimpleCov.start do
    enable_coverage :branch
    add_filter '/spec/'
    add_filter '/vendor/'
  end
end

require 'combustion'

# Silence initialization
@orig_stdout = $stdout
$stdout = File.open(File::NULL, 'w')

Combustion.path = 'spec/rails_app'
Combustion.initialize! :all do
  config.logger = Epilog::MockLogger.new
  config.logger.progname = 'epilog'
  config.log_level = :debug
  config.action_controller.perform_caching = true
  config.cache_store = [:file_store, File.join(Rails.root, 'tmp/cache')]
  config.filter_parameters = %w[password]

  if Rails::VERSION::MAJOR == 5
    config.active_record.sqlite3.represent_boolean_as_integer = true
  end
end

$stdout = @orig_stdout

require 'epilog'
require 'rspec/rails'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  config.before do
    Rails.logger.reset
  end

  config.after do
    FileUtils.rm_rf(File.join(Rails.root, 'tmp'))
  end
end
