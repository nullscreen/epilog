# frozen_string_literal: true

module Details
  module Rails
    class Railtie < ::Rails::Railtie
      SUBSCRIBERS = {
        action_controller: ActionControllerSubscriber,
        action_mailer: ActionMailerSubscriber,
        action_view: ActionViewSubscriber,
        active_record: ActiveRecordSubscriber
      }.freeze

      config.details = ActiveSupport::OrderedOptions.new(
        subscriber_blacklist: [
          ActionController::LogSubscriber,
          ActionMailer::LogSubscriber,
          ActionView::LogSubscriber,
          ActiveRecord::LogSubscriber
        ],
        subscriptions: [
          :action_controller,
          :action_mailer,
          :action_view,
          :active_record
        ]
      )

      initializer 'details.configure' do |app|
        app.config.details.logger ||= Rails.logger

        disable_rails_defaults(app.config.details.subscriber_blacklist)

        app.config.details.subscriptions.each do |namespace|
          subscriber_class = SUBSCRIBERS[namespace]
          subscriber = subscriber_class.new
          subscriber.logger = app.config.details.logger
          subscriber_class.attach_to(namespace)
        end
      end

      private

      def disable_rails_defaults(blacklist)
        blacklisted_subscribers(blacklist).each do |subscriber|
          subscriber.patterns.each do |pattern|
            unsubscribe_listeners(subscriber, pattern)
          end
        end
      end

      def unsubscribe_listeners(subscriber, pattern)
        ActiveSupport::Notifications.listeners_for(pattern).each do |listener|
          if listener.delegates_to?(subscriber)
            ActiveSupport::Notifications.unsubscribe(listener)
          end
        end
      end

      def blacklisted_subscribers(blacklist)
        ActiveSupport::LogSubscriber.log_subscribers.select do |subscriber|
          blacklist.include?(subscriber.class)
        end
      end
    end
  end
end

module ActiveSupport
  module Notifications
    class Fanout
      module Subscribers
        class Evented
          def delegates_to?(delegate)
            @delegate == delegate
          end
        end
      end
    end
  end
end
