# frozen_string_literal: true

require 'action_controller/log_subscriber' if Gem.loaded_specs.key?('action_controller')
require 'action_dispatch/middleware/debug_exceptions' if Gem.loaded_specs.key?('action_dispatch')
require 'action_mailer/log_subscriber' if Gem.loaded_specs.key?('action_mailer')
require 'action_view/log_subscriber' if Gem.loaded_specs.key?('action_view')
require 'active_record/log_subscriber' if Gem.loaded_specs.key?('active_record')
require 'active_job/logging' if Gem.loaded_specs.key?('active_job')

require 'epilog/rails/ext/event_delegate'
require 'epilog/rails/ext/active_support_logger'
require 'epilog/rails/ext/rack_logger'
require 'epilog/rails/ext/action_controller' if Gem.loaded_specs.key?('action_controller')
require 'epilog/rails/ext/debug_exceptions'

require 'epilog/rails/epilog_ext'
require 'epilog/rails/log_subscriber'
require 'epilog/rails/action_controller_subscriber' if Gem.loaded_specs.key?('action_controller')
require 'epilog/rails/action_mailer_subscriber' if Gem.loaded_specs.key?('action_mailer')
require 'epilog/rails/action_view_subscriber' if Gem.loaded_specs.key?('action_view')
require 'epilog/rails/active_record_subscriber' if Gem.loaded_specs.key?('active_record')
require 'epilog/rails/active_job_subscriber' if Gem.loaded_specs.key?('active_job')
require 'epilog/rails/railtie'
