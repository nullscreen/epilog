# frozen_string_literal: true

module Epilog
  module ActionControllerExt
    def process_action(*)
      epilog_instrument('request_received')
      epilog_instrument('process_request') do |payload|
        begin
          super
        ensure
          payload[:response] = response
          payload[:metrics] = epilog_metrics
        end
      end
    end

    private

    def epilog_instrument(name, &block)
      ActiveSupport::Notifications.instrument(
        "#{name}.action_controller",
        epilog_payload,
        &block
      )
    end

    def epilog_payload
      {
        request: request,
        response: response,
        controller: self.class.name,
        action: action_name,
        context: epilog_context
      }
    end

    def epilog_metrics
      {
        db_runtime: try(:db_runtime),
        view_runtime: view_runtime
      }
    end

    def epilog_context
      {}
    end
  end
end

def prepend_controller_ext
  ActionController::Base.prepend(Epilog::ActionControllerExt)
  return unless defined? ActionController::API

  ActionController::API.prepend(Epilog::ActionControllerExt)
end

if ::Rails::VERSION::MAJOR < 5
  prepend_controller_ext
else
  ActiveSupport.on_load(:action_controller_base) do
    prepend_controller_ext
  end
end
