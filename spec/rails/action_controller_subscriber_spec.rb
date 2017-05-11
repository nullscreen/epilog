# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe Epilog::Rails::ActionControllerSubscriber do
  describe EmptyController, type: :controller do
    render_views

    it 'logs a normal GET request' do
      get(:index)

      expect(Rails.logger[0][0]).to eq('INFO')
      expect(Rails.logger[0][3]).to match(
        message: 'GET /empty started',
        request: {
          method: 'GET',
          path: '/empty',
          params: {},
          format: :html,
          controller: 'EmptyController',
          action: 'index'
        }
      )

      expect(Rails.logger[1][0]).to eq('INFO')
      expect(Rails.logger[1][3]).to match(
        message: 'GET /empty > 200 OK',
        request: {
          method: 'GET',
          path: '/empty',
          params: {},
          format: :html,
          controller: 'EmptyController',
          action: 'index'
        },
        response: {
          status: 200
        },
        metrics: {
          db_runtime: 0,
          view_runtime: be_within(10).of(10),
          request_runtime: be_between(0, 10).exclusive
        }
      )
    end

    it 'logs a request with unpermitted parameters' do
      get(:index, foo: 'bar')

      expect(Rails.logger[1][0]).to eq('DEBUG')
      expect(Rails.logger[1][3]).to match(
        message: 'Unpermitted parameters: foo',
        metrics: {
          event_duration: be_between(0, 10).exclusive
        }
      )
    end
  end

  describe RedirectController, type: :controller do
    it 'logs a redirect response' do
      get(:index)

      expect(Rails.logger[1][0]).to eq('INFO')
      expect(Rails.logger[1][3]).to match(
        message: 'Redirect > https://www.google.com',
        metrics: {
          event_duration: be_between(0, 10).exclusive
        }
      )
    end
  end

  describe DataController, type: :controller do
    render_views

    it 'logs a data response' do
      get(:index)

      expect(Rails.logger[1][0]).to eq('INFO')
      expect(Rails.logger[1][3]).to match(
        message: 'Sent data test.txt',
        metrics: {
          event_duration: be_between(0, 10).exclusive
        }
      )
    end
  end

  describe FileController, type: :controller do
    it 'logs a file response' do
      filename = File.join(Rails.root, 'public/test.txt')

      get(:index)

      expect(Rails.logger[1][0]).to eq('INFO')
      expect(Rails.logger[1][3]).to match(
        message: "Sent file #{filename}",
        metrics: {
          event_duration: be_between(0, 10).exclusive
        }
      )
    end
  end

  describe HaltController, type: :controller do
    render_views

    it 'logs a halted request' do
      get(:index)

      expect(Rails.logger[1][0]).to eq('INFO')
      expect(Rails.logger[1][3]).to match(
        message: 'Filter chain halted as :halt rendered or redirected',
        metrics: {
          event_duration: be_within(1).of(0)
        }
      )
    end
  end

  describe FragmentController, type: :controller do
    render_views

    it 'logs fragment caching in a request' do
      get(:index)

      expect(Rails.logger[3][3]).to match(
        message: start_with('read_fragment views/'),
        metrics: {
          event_duration: be_between(0, 10).exclusive
        }
      )

      expect(Rails.logger[4][3]).to match(
        message: start_with('write_fragment views/'),
        metrics: {
          event_duration: be_between(0, 10).exclusive
        }
      )
    end
  end
end
