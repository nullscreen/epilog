# frozen_string_literal: true

module Epilog
  module Rails
    class ActiveJobSubscriber < LogSubscriber
      def enqueue(event)
        info { event_hash('Enqueued job', event) }
      end

      def enqueue_at(event)
        enqueue(event)
      end

      def perform_start(event)
        push_context(job: short_job_hash(event.payload[:job]))
        info { event_hash('Performing job', event) }
      end

      def perform(event)
        info do
          event_hash('Performed job', event).merge(
            metrics: {
              job_runtime: event.duration
            }
          )
        end
        pop_context
      end

      private

      def event_hash(message, event)
        {
          message: message,
          job: job_hash(event.payload[:job]),
          adapter: adapter_name(event.payload[:adapter])
        }
      end

      def job_hash(job)
        {
          class: job.class.name,
          id: job.job_id,
          queue: job.queue_name,
          arguments: job.arguments,
          scheduled_at: job.scheduled_at ? format_time(job.scheduled_at) : nil
        }
      end

      def short_job_hash(job)
        {
          class: job.class.name,
          id: job.job_id
        }
      end

      def format_time(time)
        Time.at(time).utc.strftime(Epilog::Formatter::DEFAULT_TIME_FORMAT)
      end

      def adapter_name(adapter)
        adapter = adapter.class unless adapter.is_a?(Class)
        adapter.name
      end
    end
  end
end
