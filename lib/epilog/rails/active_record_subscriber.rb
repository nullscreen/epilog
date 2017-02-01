# frozen_string_literal: true

module Epilog
  module Rails
    class ActiveRecordSubscriber < LogSubscriber
      IGNORE_PAYLOAD_NAMES = %w[SCHEMA EXPLAIN].freeze

      def sql(event)
        ActiveRecord::LogSubscriber.runtime += event.duration

        return unless logger.debug?
        payload = event.payload
        return if IGNORE_PAYLOAD_NAMES.include?(payload[:name])

        debug(
          message: payload[:name],
          sql: payload[:sql],
          binds: binds_info(payload[:binds]),
          metrics: {
            query_runtime: event.duration.round(2)
          }
        )
      end

      private

      def binds_info(binds)
        binds.map do |column, value|
          info = { type: column.type, name: column.name }
          if column.binary?
            info[:bytes] = value.bytesize
          else
            info[:value] = value
          end
          info
        end
      end
    end
  end
end
