# frozen_string_literal: true

module Epilog
  class Logger
    def silencer
      false
    end
  end
end

logger_silencer = if Rails::VERSION::MAJOR >= 6
  ActiveSupport::LoggerSilence
else
  ::LoggerSilence
end
Epilog::Logger.send(:include, logger_silencer)
