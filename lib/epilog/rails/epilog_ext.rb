# frozen_string_literal: true

module Epilog
  class Logger
    def silencer
      false
    end
  end
end

Epilog::Logger.send(:include, defined?(ActiveSupport::LoggerSilence) ? ActiveSupport::LoggerSilence : ::LoggerSilence)
