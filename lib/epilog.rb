# frozen_string_literal: true

require 'logger'

require 'epilog/version'
require 'epilog/logger'
require 'epilog/mock_logger'
require 'epilog/log_formatter'
require 'epilog/filter'
require 'epilog/rails' if defined?(Rails)
