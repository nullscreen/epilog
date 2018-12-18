# frozen_string_literal: true

class TestJob < ActiveJob::Base
  queue_as 'test-queue'
  self.queue_adapter = :inline

  def perform
  end

  def job_id
    'test-id'
  end
end

# rubocop: disable BlockLength
RSpec.describe Epilog::Rails::ActiveJobSubscriber do
  it 'logs inline execution' do
    TestJob.perform_later

    expect(Rails.logger[0][0]).to eq('INFO')
    expect(Rails.logger[0][3]).to match(
      message: 'Performing job',
      job: {
        class: 'TestJob',
        id: 'test-id',
        queue: 'test-queue',
        arguments: [],
        scheduled_at: nil
      },
      adapter: 'ActiveJob::QueueAdapters::InlineAdapter'
    )

    expect(Rails.logger[1][0]).to eq('INFO')
    expect(Rails.logger[1][3]).to match(
      message: 'Performed job',
      job: {
        class: 'TestJob',
        id: 'test-id',
        queue: 'test-queue',
        arguments: [],
        scheduled_at: nil
      },
      adapter: 'ActiveJob::QueueAdapters::InlineAdapter',
      metrics: {
        job_runtime: be_between(0, 10)
      }
    )

    expect(Rails.logger[2][0]).to eq('INFO')
    expect(Rails.logger[2][3]).to match(
      message: 'Enqueued job',
      job: {
        class: 'TestJob',
        id: 'test-id',
        queue: 'test-queue',
        arguments: [],
        scheduled_at: nil
      },
      adapter: 'ActiveJob::QueueAdapters::InlineAdapter'
    )
  end
end
# rubocop:enable BlockLength
