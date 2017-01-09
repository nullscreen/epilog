# frozen_string_literal: true

module Details
  module Rails
    class ActionControllerSubscriber < ActiveSupport::LogSubscriber
      RAILS_PARAMS = %i(controller action format _method only_path).freeze
      RESPONSE_STATS = %(db_runtime view_runtime).freeze

      attr_reader :logger

      def start_processing(event)
        info do
          {
            message: "#{message[:request][:method]} " \
              "#{message[:request][:path]}",
            request: request(event)
          }
        end
      end

      def process_action(event)
        info do
          status = normalize_status(payload[:status], event)
          {
            message: "#{status} #{Rack::Utils::HTTP_STATUS_CODES[status]}",
            request: { id: event.transaction_id },
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
        info do
          basic_message(event, "Redirected to #{event.payload[:location]}")
        end
      end

      def halted_callback(event)
        info do
          basic_message('Filter chain halted as ' \
            "#{event.payload[:filter].inspect} rendered or redirected")
        end
      end

      def unpermitted_parameters(event)
        debug do
          basic_message('Unpermitted parameters ' \
            "#{event.payload[:keys].join(', ')}")
        end
      end

      %i(
        write_fragment
        read_fragment
        exist_fragment?
        expire_fragment
        expire_page
        write_page
      ).each do |method|
        define_method(method) do |event|
          return unless logger.info?
          return unless ActionController::Base.enable_fragment_cache_logging

          info(basic_message("#{method.to_s.humanize.inspect} " \
            "#{event.payload[:key] || event.payload[:path]}"))
        end
      end

      private

      def request(event)
        payload = event.payload

        {
          id: event.transaction_id,
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

      def basic_message(message, event)
        {
          message: message,
          request: { id: event.transaction_id },
          metrics: { duration: event.duration }
        }
      end
    end
  end
end
