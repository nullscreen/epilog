# frozen_string_literal: true

module Epilog
  module Rails
    class Railtie < ::Rails::Railtie
      SUBSCRIBERS = {
        action_controller: ActionControllerSubscriber,
        action_mailer: ActionMailerSubscriber,
        action_view: ActionViewSubscriber,
        active_record: ActiveRecordSubscriber
      }.freeze

      config.epilog = ActiveSupport::OrderedOptions.new
      config.epilog.logger = nil
      config.epilog.subscriber_blacklist = [
        ActionController::LogSubscriber,
        ActionMailer::LogSubscriber,
        ActionView::LogSubscriber,
        ActiveRecord::LogSubscriber
      ]
      config.epilog.subscriptions = [
        :action_controller,
        :action_mailer,
        :action_view,
        :active_record
      ]

      initializer 'epilog.configure' do |app|
        app.config.epilog.logger ||= ::Rails.logger || Logger.new($stdout)

        disable_rails_defaults(app.config.epilog.subscriber_blacklist)

        app.config.epilog.subscriptions.each do |namespace|
          subscriber_class = SUBSCRIBERS[namespace]
          subscriber_class.attach_to(
            namespace,
            subscriber_class.new(app.config.epilog.logger)
          )
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
        notifier = ActiveSupport::Notifications.notifier
        notifier.listeners_for(pattern).each do |listener|
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
