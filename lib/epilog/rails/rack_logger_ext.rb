# frozen_string_literal: true

module Rails
  module Rack
    class Logger
      def logger
        @logger ||= ::Logger.new(File::NULL)
      end
    end
  end
end
