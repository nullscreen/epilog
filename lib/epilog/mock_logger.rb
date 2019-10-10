# frozen_string_literal: true

module Epilog
  class MockLogger < ::Logger
    def initialize(**options)
      super(nil, **options)
      reset
    end

    # rubocop:disable MethodLength
    def add(severity, message = nil, progname = nil)
      severity ||= Logger::UNKNOWN
      return true if severity < level

      prog ||= progname
      if message.nil?
        if block_given?
          message = yield
        else
          message = prog
          prog = progname
        end
      end

      write(format_severity(severity), current_time, prog, message)
    end
    # rubocop:enable MethodLength
    alias log add

    def reopen(_logdev = nil)
    end

    def [](index)
      @logs[index].dup || []
    end

    def to_a
      (0...@logs.size).map { |i| self[i] }
    end

    def freeze_time(time)
      @time = time
    end

    def reset
      @logs = []
      @context = []
    end

    def with_context(context)
      push_context(context)
      yield
      pop_context
    end

    def push_context(context)
      @context << context
    end

    def pop_context
      @context.pop
    end

    private

    def current_time
      @time || Time.now
    end

    def write(severity, time, prog, message)
      @logs << [severity, time, prog, message, @context.dup]
    end
  end
end
