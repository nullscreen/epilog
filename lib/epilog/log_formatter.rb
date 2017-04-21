# frozen_string_literal: true

module Epilog
  class Formatter
    SEVERITY_MAP = {
      'FATAL' => 'ALERT',
      'WARN' => 'WARNING'
    }.freeze

    DEFAULT_TIME_FORMAT = '%Y-%m-%dT%H:%M:%S%z'

    attr_reader :filter
    attr_writer :datetime_format

    def initialize(options = {})
      @filter = options[:filter] || Filter::Blacklist.new
    end

    def call(severity, time, progname, msg)
      log = base_log(severity, time, progname)
      log.merge!(message(msg))

      if log[:exception].is_a?(Exception)
        log[:exception] = format_error(log[:exception])
      end

      log = before_write(log)
      "#{JSON.dump(log)}\n"
    end

    def datetime_format
      @datetime_format || DEFAULT_TIME_FORMAT
    end

    private

    def base_log(severity, time, progname)
      {
        timestamp: time.strftime(datetime_format),
        severity: SEVERITY_MAP[severity] || severity,
        source: progname
      }
    end

    def message(msg)
      return { message: msg.message, exception: msg } if msg.is_a?(Exception)
      return msg.to_h if msg.respond_to?(:to_h)
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

    def before_write(log)
      @filter ? @filter.call(log) : log
    end
  end
end
