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

# a workaround to avoid MonitorMixin double-initialize error
# https://github.com/rails/rails/issues/34790#issuecomment-681034561
if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.6.0')
  if Gem::Version.new(::Rails.version) < Gem::Version.new('5.0.0')
    # rubocop:disable Style/ClassAndModuleChildren
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.7.0')
          @mon_data = nil
          @mon_data_owner_object_id = nil
        else
          @mon_mutex = nil
          @mon_mutex_owner_object_id = nil
        end
        initialize
      end
    end
    # rubocop:enable Style/ClassAndModuleChildren
  else
    puts(
      'Monkeypatch for ActionController::TestResponse is no longer needed'
    )
  end
end

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
