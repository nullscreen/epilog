# frozen_string_literal: true

module Epilog
  module Rails
    class ActionMailerSubscriber < LogSubscriber
      def deliver(event)
        info do
          hash(
            event,
            message: 'Sent mail',
            recipients: Array(event.payload[:to])
          )
        end
      end

      # Method `receive` removed in Rails 6.1
      # https://github.com/rails/rails/commit/d5fa9569a0d401893d54ee47fe43fd87b6155fb7
      def receive(event)
        info do
          hash(
            event,
            message: 'Received mail'
          )
        end
      end

      def process(event)
        debug do
          hash(
            event,
            message: 'Processed outbound mail',
            mailer: event.payload[:mailer],
            action: event.payload[:action]
          )
        end
      end

      private

      def hash(event, attrs = {})
        if logger.debug? && event.payload[:mail]
          attrs[:body] = event.payload[:mail]
        end

        attrs[:metrics] = { duration: event.duration.round(2) }
        attrs
      end
    end
  end
end
