# frozen_string_literal: true

module Epilog
  module ContextLogger
    def with_context(context)
      push_context(context)
      yield
      pop_context
    end

    def push_context(context)
      formatter.push_context(context)
    end

    def pop_context
      formatter.pop_context
    end
  end

  module ContextFormatter
    def context
      Thread.current[current_context_key] ||= begin
        result = {}
        context_stack.each { |frame| result.merge!(frame) }
        result
      end.freeze
    end

    def push_context(frame)
      clear_context
      context_stack.push(frame)
    end

    def pop_context
      clear_context
      context_stack.pop
    end

    private

    def clear_context
      Thread.current[current_context_key] = nil
    end

    def context_stack
      Thread.current[stack_key] ||= []
    end

    def stack_key
      @stack_key ||= "epilog_context_stack:#{object_id}"
    end

    def current_context_key
      @current_context_key ||= "epilog_context_current:#{object_id}"
    end
  end
end
