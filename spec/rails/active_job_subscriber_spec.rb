# frozen_string_literal: true

class TestJob < ActiveJob::Base
  queue_as 'test-queue'

  def perform
  end

  def job_id
    'test-id'
  end
end

# rubocop: disable BlockLength
RSpec.describe Epilog::Rails::ActiveJobSubscriber do
  before { Timecop.freeze(Time.local(2017, 1, 10, 5, 0)) }
  after { Timecop.return }

  it 'logs inline execution' do
    expect(Rails.logger.formatter).to receive(:call).with(
      'INFO',
      Time.now,
      'epilog',
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

    expect(Rails.logger.formatter).to receive(:call).with(
      'INFO',
      Time.now,
      'epilog',
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
        job_runtime: 0.0
      }
    )

    expect(Rails.logger.formatter).to receive(:call).with(
      'INFO',
      Time.now,
      'epilog',
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
    TestJob.perform_later
  end
end
