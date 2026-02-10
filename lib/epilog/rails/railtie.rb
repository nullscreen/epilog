# frozen_string_literal: true

module Epilog
  module Rails
    class Railtie < ::Rails::Railtie
      def self.rails_6_1_higher?
        Gem::Version.new(::Rails::VERSION::STRING) >= Gem::Version.new('6.1.0')
      end

      # We need this in Rails 6.
      # Without this line `ActiveJob::LogSubscriber` fails
      # with unknown contant error
      ActiveSupport.run_load_hooks(:active_job, ActiveJob::Base)

      SUBSCRIBERS = {
        action_controller: ActionControllerSubscriber,
        action_mailer: ActionMailerSubscriber,
        action_view: ActionViewSubscriber,
        active_record: ActiveRecordSubscriber,
        active_job: ActiveJobSubscriber
      }.freeze

      SUBSCRIBER_BLACKLIST = [
        ActionController::LogSubscriber,
        ActionMailer::LogSubscriber,
        ActionView::LogSubscriber,
        ActiveRecord::LogSubscriber,
        if rails_6_1_higher?
          ActiveJob::LogSubscriber
        else
          ActiveJob::Logging::LogSubscriber
        end
      ].freeze

      config.epilog = ActiveSupport::OrderedOptions.new
      config.epilog.double_request_logs = true
      config.epilog.double_job_logs = true
      config.epilog.subscriptions = %i[
        action_controller
        action_mailer
        action_view
        active_record
        active_job
      ]

      initializer 'epilog.configure' do |app|
        ::Rails.logger ||= Logger.new($stdout)

        app.config.epilog.subscriptions.each do |namespace|
          subscriber_class = SUBSCRIBERS[namespace]
          subscriber_class.attach_to(
            namespace,
            subscriber_class.new(::Rails.logger)
          )
        end
      end

      # In Rails 7.1+, ActionView::LogSubscriber::Start are attached late
      # in the initialization process, so we need to disable them after
      # initialization completes
      config.after_initialize do
        disable_rails_defaults
        prevent_double_logs_from_broadcast
      end

      class << self
        private

        def disable_rails_defaults
          blacklisted_subscribers.each do |subscriber|
            subscriber.patterns.each do |pattern|
              unsubscribe_listeners(subscriber, pattern)
            end
          end

          # Rails 7.1 adds ActionView::LogSubscriber::Start which subscribes
          # separately and logs "Rendering..." messages at the start of rendering
          # see https://github.com/rails/rails/commit/9c58a54702b038b9acebdb3efa85c26156ff1987#diff-fd389a9f74e2259b56015e3f8d15a5ce33c093045dd4cb354e82d6d81fe9b06aR98-R99
          unsubscribe_action_view_start_listeners
        end

        def unsubscribe_listeners(subscriber, pattern)
          notifier = ActiveSupport::Notifications.notifier
          notifier.listeners_for(Array.wrap(pattern).first).each do |listener|
            if listener.delegates_to?(subscriber)
              ActiveSupport::Notifications.unsubscribe(listener)
            end
          end
        end

        def unsubscribe_action_view_start_listeners
          return unless defined?(ActionView::LogSubscriber::Start)

          notifier = ActiveSupport::Notifications.notifier
          %w[render_template.action_view render_layout.action_view].each do |pattern|
            notifier.listeners_for(pattern).each do |listener|
              if listener.delegate.is_a?(ActionView::LogSubscriber::Start)
                ActiveSupport::Notifications.unsubscribe(listener)
              end
            end
          end
        end

        # In Rails 7.1+, the server and console call Rails.logger.broadcast_to(console)
        # which adds a second logger and causes every log line to appear twice
        # (e.g. custom format + default Logger format). Override broadcast_to with
        # a no-op to prevent adding duplicate destinations.
        #
        # This must be done in after_initialize (not at require time) because:
        # 1. Rails wraps the logger in a BroadcastLogger during bootstrap
        # 2. We need to override the instance method on the actual Rails.logger
        def prevent_double_logs_from_broadcast
          return if ::Rails.gem_version < Gem::Version.new('7.1')
          return unless ::Rails.logger

          ::Rails.logger.define_singleton_method(:broadcast_to) { |*| nil }
        end

        def blacklisted_subscribers
          ActiveSupport::LogSubscriber.log_subscribers.select do |subscriber|
            SUBSCRIBER_BLACKLIST.include?(subscriber.class)
          end
        end
      end
    end
  end
end
