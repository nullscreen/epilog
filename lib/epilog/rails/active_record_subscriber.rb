# frozen_string_literal: true

module Epilog
  module Rails
    class ActiveRecordSubscriber < LogSubscriber
      IGNORE_PAYLOAD_NAMES = %w[SCHEMA EXPLAIN].freeze

      def sql(event)
        ActiveRecord::RuntimeRegistry.sql_runtime += event.duration

        return unless logger.debug?

        payload = event.payload
        return if IGNORE_PAYLOAD_NAMES.include?(payload[:name])

        debug(
          message: payload[:name],
          sql: payload[:sql],
          binds: binds_info(payload[:binds] || []),
          metrics: metrics(event)
        )
      end

      private

      def metrics(event)
        {
          query_runtime: event.duration.round(2)
        }
      end

      def binds_info(binds)
        binds.map do |bind|
          if bind.is_a?(Array)
            bind_column_info(*bind)
          else
            bind_attr_info(bind)
          end
        end
      end

      def bind_column_info(column, value)
        info = { type: column.type, name: column.name }
        if column.binary?
          info[:bytes] = value.bytesize
        else
          info[:value] = value
        end
        info
      end

      def bind_attr_info(attr)
        info = { type: attr.type.type, name: attr.name }
        if attr.type.binary? && attr.value
          info[:bytes] = attr.value_for_database.to_s.bytesize
        else
          info[:value] = attr.value_for_database
        end
        info
      end
    end
  end
end
