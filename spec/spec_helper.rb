# frozen_string_literal: true

require 'byebug'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/vendor/'
  end
end

require 'combustion'

Combustion.path = 'spec/rails_app'
Combustion.initialize! :all do
  config.logger = Epilog::MockLogger.new
  config.logger.progname = 'epilog'
  config.log_level = :debug
  config.action_controller.perform_caching = true
  config.cache_store = [:file_store, File.join(Rails.root, 'tmp/cache')]
end
require 'timecop'
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

  config.use_transactional_fixtures = true

  config.after do
    Rails.logger.reset
    FileUtils.rm_rf(File.join(Rails.root, 'tmp'))
  end
end
