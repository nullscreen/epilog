# frozen_string_literal: true

class TestJob < ActiveJob::Base
  queue_as 'test-queue'
  self.queue_adapter = :inline

  def perform
    Rails.logger.info('User log')
  end

  def job_id
    'test-id'
  end
end

class TestErrorJob < ActiveJob::Base
  queue_as 'test-queue'
  self.queue_adapter = :inline

  def perform
    raise 'Something went wrong'
  end
end

RSpec.describe Epilog::Rails::ActiveJobSubscriber do
  it 'logs inline execution' do
    TestJob.perform_later
    context = { job: { class: 'TestJob', id: 'test-id' } }

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
    expect(Rails.logger[0][4]).to match([context])

    expect(Rails.logger[1][3]).to eq('User log')
    expect(Rails.logger[1][4]).to match([context])

    expect(Rails.logger[2][0]).to eq('INFO')
    expect(Rails.logger[2][3]).to match(
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
        job_runtime: be_between(0, 100)
      }
    )
    expect(Rails.logger[2][4]).to match([context])

    expect(Rails.logger[3][0]).to eq('INFO')
    expect(Rails.logger[3][3]).to match(
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

  context 'with double_job_logs = false' do
    around do |example|
      Rails.application.config.epilog.double_job_logs = false
      example.run
      Rails.application.config.epilog.double_job_logs = true
    end

    it 'skips start log' do
      TestJob.perform_later
      expect(Rails.logger[1][3]).to match(hash_including(
        message: 'Performed job'
      ))
    end
  end

  describe TestErrorJob do
    it 'resets context after error' do
      expect { described_class.perform_later }
        .to raise_error('Something went wrong')

      Rails.logger.info('middle')

      expect { described_class.perform_later }
        .to raise_error('Something went wrong')

      job_context = [job: hash_including(class: 'TestErrorJob')]
      expect(Rails.logger[0][4]).to match(job_context)
      expect(Rails.logger[2][4]).to eq([])
      log_line = Rails::VERSION::MAJOR >= 6 ? 4 : 3
      expect(Rails.logger[log_line][4]).to match(job_context)
    end
  end
end
