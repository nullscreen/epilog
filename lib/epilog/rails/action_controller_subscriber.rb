# frozen_string_literal: true

module Epilog
  module Rails
    class ActionControllerSubscriber < LogSubscriber
      RAILS_PARAMS = %i[controller action format _method only_path].freeze

      def request_received(event)
        info do
          {
            message: "#{request_string(event)} started",
            request: request_hash(event)
          }
        end
      end

      def process_request(event)
        info do
          {
            message: response_string(event),
            request: request_hash(event),
            response: response_hash(event),
            metrics: event.payload[:metrics]
              .merge(request_runtime: event.duration)
          }
        end
      end

      def start_processing(*)
      end

      def process_action(*)
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

      def request_hash(event)
        request = event.payload[:request]
        {
          method: request.request_method,
          path: request.fullpath,
          params: request.filtered_parameters.except(*RAILS_PARAMS),
          format: request.format.try(:ref),
          controller: event.payload[:controller],
          action: event.payload[:action]
        }
      end

      def request_string(event)
        request = event.payload[:request]
        "#{request.request_method} #{request.fullpath}"
      end

      def response_hash(event)
        { status: normalize_status(event) }
      end

      def response_string(event)
        status = normalize_status(event)
        status_string = Rack::Utils::HTTP_STATUS_CODES[status]
        "#{request_string(event)} > #{status} #{status_string}"
      end

      def normalize_status(event)
        payload = event.payload
        status = payload[:response].status
        if status.nil? && payload[:exception].present?
          status = ActionDispatch::ExceptionWrapper
            .status_code_for_exception(payload[:exception].first)
        end
        status
      end

      def basic_message(event, message)
        {
          message: message,
          metrics: { event_duration: event.duration }
        }
      end
    end
  end
end
