# frozen_string_literal: true

module Rails
  module Rack
    class Logger
      # The Rails rack logger extension adds unformatted log output with
      # duplicate information. Disable those logs completely.
      def logger
        @logger ||= ::Logger.new(nil)
      end
    end
  end
end
