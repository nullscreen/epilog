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
      ActiveSupport.run_load_hooks(:active_job, ActiveJob::Base) if defined?(ActiveJob::Base)

      SUBSCRIBERS = {
        action_controller: 'ActionControllerSubscriber',
        action_mailer: 'ActionMailerSubscriber',
        action_view: 'ActionViewSubscriber',
        active_record: 'ActiveRecordSubscriber',
        active_job: 'ActiveJobSubscriber'
      }.freeze

      SUBSCRIBER_BLACKLIST = [
        'ActionController::LogSubscriber',
        'ActionMailer::LogSubscriber',
        'ActionView::LogSubscriber',
        'ActiveRecord::LogSubscriber',
        if rails_6_1_higher?
          'ActiveJob::LogSubscriber'
        else
          'ActiveJob::Logging::LogSubscriber'
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
        disable_rails_defaults

        ::Rails.logger ||= Logger.new($stdout)

        app.config.epilog.subscriptions.each do |namespace|
          subscriber_class = SUBSCRIBERS[namespace].safe_constantize
          next unless subscriber_class

          subscriber_class.attach_to(
            namespace,
            subscriber_class.new(::Rails.logger)
          )
        end
      end

      private

      def disable_rails_defaults
        blacklisted_subscribers.each do |subscriber|
          subscriber.patterns.each do |pattern|
            unsubscribe_listeners(subscriber, pattern)
          end
        end
      end

      def unsubscribe_listeners(subscriber, pattern)
        notifier = ActiveSupport::Notifications.notifier
        notifier.listeners_for(Array.wrap(pattern).first).each do |listener|
          if listener.delegates_to?(subscriber)
            ActiveSupport::Notifications.unsubscribe(listener)
          end
        end
      end

      def blacklisted_subscribers
        ActiveSupport::LogSubscriber.log_subscribers.select do |subscriber|
          SUBSCRIBER_BLACKLIST.include?(subscriber.class.name)
        end
      end
    end
  end
end
