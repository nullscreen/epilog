# frozen_string_literal: true
module Epilog
  class Formatter
    SEVERITY_MAP = {
      'FATAL' => 'ALERT',
      'WARN' => 'WARNING'
    }.freeze

    TIME_FORMAT = '%Y-%m-%dT%H:%M:%S%z'.freeze

    def call(severity, time, progname, msg)
      log = base_log(severity, time, progname)
      log.merge!(message(msg))

      if log[:exception].is_a?(Exception)
        log[:exception] = format_error(log[:exception])
      end

      "#{JSON.dump(log)}\n"
    end

    private

    def base_log(severity, time, progname)
      {
        timestamp: time.strftime(TIME_FORMAT),
        severity: SEVERITY_MAP[severity] || severity,
        source: progname
      }
    end

    def message(msg)
      return { message: msg.message, exception: msg } if msg.is_a?(Exception)
      return message.to_h if message.respond_to?(:to_h)
      { message: msg.to_s }
    end

    def format_error(error)
      hash = {
        name: error.class.name,
        message: error.message,
        trace: error.backtrace
      }
      cause = error.cause
      hash[:parent] = format_error(cause) unless cause.nil?
      hash
    end
  end
end
