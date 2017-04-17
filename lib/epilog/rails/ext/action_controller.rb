# frozen_string_literal: true

module Epilog
  module ActionControllerExt
    def process_action(*)
      ActiveSupport::Notifications.instrument(
        'request_received.action_controller',
        controller: self.class.name,
        action: action_name,
        request: request
      )

      process_payload = {
        request: request,
        response: response,
        controller: self.class.name,
        action: action_name
      }
      ActiveSupport::Notifications.instrument(
        'process_request.action_controller',
        process_payload
      ) do
        begin
          super
        ensure
          process_payload[:metrics] = metrics
        end
      end
    end

    def metrics
      {
        db_runtime: ActiveRecord::RuntimeRegistry.sql_runtime,
        view_runtime: view_runtime
      }.keep_if { |_k, v| !v.nil? }
    end
  end
end

ActionController::Base.prepend(Epilog::ActionControllerExt)
