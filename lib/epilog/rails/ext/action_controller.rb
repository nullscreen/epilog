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
        action: action_name
      }
    end

    def epilog_metrics
      {
        db_runtime: ActiveRecord::RuntimeRegistry.sql_runtime,
        view_runtime: view_runtime
      }.keep_if { |_k, v| !v.nil? }
    end
  end
end

ActionController::Base.prepend(Epilog::ActionControllerExt)
