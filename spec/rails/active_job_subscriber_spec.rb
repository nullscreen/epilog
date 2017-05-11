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
        job_runtime: 0.0
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
