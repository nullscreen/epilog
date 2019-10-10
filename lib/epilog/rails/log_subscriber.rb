# frozen_string_literal: true

module Epilog
  module Rails
    class LogSubscriber < ActiveSupport::LogSubscriber
      attr_reader :logger

      def initialize(logger)
        super()
        @logger = logger
      end

      def push_context(context)
        @logger.try(:push_context, context)
      end

      def pop_context
        @logger.try(:pop_context)
      end
    end
  end
end
