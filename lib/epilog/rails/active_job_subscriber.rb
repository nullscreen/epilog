# frozen_string_literal: true

module Epilog
  module Rails
    class ActiveJobSubscriber < LogSubscriber
      def enqueue(event)
        ex = event.payload[:exception_object]

        if ex
          error do
            event_hash('Failed enqueuing job', event)
          end
        elsif event.payload[:aborted]
          info do
            event_hash(
              'Failed enqueuing job, a before_enqueue callback ' \
                'halted the enqueuing execution.',
              event
            )
          end
        else
          info { event_hash('Enqueued job', event) }
        end
      end

      def enqueue_at(event)
        enqueue(event)
      end

      def perform_start(event)
        push_context(job: short_job_hash(event.payload[:job]))
        return unless config.double_job_logs

        info { event_hash('Performing job', event) }
      end

      # rubocop:disable Metrics/MethodLength
      def perform(event)
        ex = event.payload[:exception_object]
        if ex
          error do
            event_hash('Error performing job', event).merge(
              metrics: {
                job_runtime: event.duration
              }
            )
          end
        elsif event.payload[:aborted]
          error do
            event_hash(
              'Error performing job, a before_perform ' \
                'callback halted the job execution',
              event
            ).merge(
              metrics: {
                job_runtime: event.duration
              }
            )
          end
        else
          info do
            event_hash('Performed job', event).merge(
              metrics: {
                job_runtime: event.duration
              }
            )
          end
        end

        pop_context
      end
      # rubocop:enable Metrics/MethodLength

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
