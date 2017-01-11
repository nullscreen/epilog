# frozen_string_literal: true

module Epilog
  module Rails
    class LogSubscriber < ActiveSupport::LogSubscriber
      attr_reader :logger

      def initialize(logger)
        super()
        @logger = logger
      end
    end
  end
end
