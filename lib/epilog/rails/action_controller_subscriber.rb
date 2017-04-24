# frozen_string_literal: true

module Epilog
  module Rails
    class ActionControllerSubscriber < LogSubscriber
      RAILS_PARAMS = %i[controller action format _method only_path].freeze
      RESPONSE_STATS = %i[db_runtime view_runtime].freeze

      def start_processing(event)
        info do
          {
            message: "#{event.payload[:method]} " \
              "#{event.payload[:path]} started",
            request: request(event)
          }
        end
      end

      def process_action(event)
        info do
          status = normalize_status(event.payload[:status], event)
          {
            message: "#{event.payload[:method]} #{event.payload[:path]} > " \
              "#{status} #{Rack::Utils::HTTP_STATUS_CODES[status]}",
            request: request(event),
            response: { status: status },
            metrics: response_metrics(event)
          }
        end
      end

      def send_data(event)
        info { basic_message(event, "Sent data #{event.payload[:filename]}") }
      end

      def send_file(event)
        info { basic_message(event, "Sent file #{event.payload[:path]}") }
      end

      def redirect_to(event)
        info { basic_message(event, "Redirect > #{event.payload[:location]}") }
      end

      def halted_callback(event)
        info do
          basic_message(event, 'Filter chain halted as ' \
            "#{event.payload[:filter].inspect} rendered or redirected")
        end
      end

      def unpermitted_parameters(event)
        debug do
          basic_message(event, 'Unpermitted parameters: ' \
            "#{event.payload[:keys].join(', ')}")
        end
      end

      %i[
        write_fragment
        read_fragment
        exist_fragment?
        expire_fragment
        expire_page
        write_page
      ].each do |method|
        define_method(method) do |event|
          return unless logger.info?

          debug(basic_message(event, "#{method} " \
            "#{event.payload[:key] || event.payload[:path]}"))
        end
      end

      private

      def request(event)
        payload = event.payload

        {
          method: payload[:method],
          path: payload[:path],
          params: payload[:params].except(*RAILS_PARAMS),
          format: payload[:format],
          controller: payload[:controller],
          action: payload[:action]
        }
      end

      def normalize_status(status, event)
        payload = event.payload
        if status.nil? && payload[:exception].present?
          status = ActionDispatch::ExceptionWrapper
            .status_code_for_exception(payload[:exception].first)
        end
        status
      end

      def response_metrics(event)
        payload = event.payload
        RESPONSE_STATS.each_with_object({}) do |stat, metrics|
          metrics[stat] = payload[stat] if payload[stat]
        end
      end

      def basic_message(event, message)
        {
          message: message,
          metrics: { duration: event.duration }
        }
      end
    end
  end
end
