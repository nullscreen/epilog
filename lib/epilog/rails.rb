# frozen_string_literal: true

require 'action_controller/log_subscriber'
require 'action_mailer/log_subscriber'
require 'action_view/log_subscriber'
require 'active_record/log_subscriber'

require 'epilog/rails/event_delegate_ext'
require 'epilog/rails/active_support_logger_ext'
require 'epilog/rails/rack_logger_ext'

require 'epilog/rails/log_subscriber'
require 'epilog/rails/action_controller_subscriber'
require 'epilog/rails/action_mailer_subscriber'
require 'epilog/rails/action_view_subscriber'
require 'epilog/rails/active_record_subscriber'
require 'epilog/rails/railtie'
