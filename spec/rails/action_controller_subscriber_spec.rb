# frozen_string_literal: true

RSpec.describe Epilog::Rails::ActionControllerSubscriber do
  def params(values)
    Rails::VERSION::MAJOR >= 5 ? { params: values } : values
  end

  describe EmptyController, type: :controller do
    render_views

    it 'logs a normal GET request' do
      get(:index)
      context = {
        custom: 'custom context',
        request: {
          id: nil,
          method: 'GET',
          path: '/empty'
        }
      }

      expect(Rails.logger[0][0]).to eq('INFO')
      expect(Rails.logger[0][3]).to eq(
        message: 'GET /empty started',
        request: {
          id: nil,
          ip: '0.0.0.0',
          host: 'test.host',
          protocol: 'http',
          method: 'GET',
          port: 80,
          path: '/empty',
          query: {},
          cookies: {},
          headers: { 'HTTPS' => 'off' },
          params: {},
          format: :html,
          controller: 'EmptyController',
          action: 'index'
        }
      )
      expect(Rails.logger[0][4]).to eq([context])
      expect(Rails.logger[2][4]).to eq([context])

      expect(Rails.logger[3][0]).to eq('INFO')
      expect(Rails.logger[3][3]).to match(
        message: 'GET /empty > 200 OK',
        request: {
          id: nil,
          method: 'GET',
          path: '/empty'
        },
        response: {
          status: 200
        },
        metrics: {
          db_runtime: 0.0,
          view_runtime: be_within(10).of(10),
          request_runtime: be_between(0, 40)
        }
      )
      expect(Rails.logger[3][4]).to eq([context])
    end

    it 'logs a request with unpermitted parameters' do
      get(:index, **params(foo: 'bar'))

      expect(Rails.logger[1][0]).to eq('DEBUG')
      expect(Rails.logger[1][3]).to match(
        message: 'Unpermitted parameters: foo',
        metrics: {
          duration: be_between(0, 40)
        }
      )
    end

    it 'removes default Rails params' do
      get(:index, **params(foo: 'bar', password: 'secret'))

      expect(Rails.logger[0][3]).to include(
        message: 'GET /empty started',
        request: include(
          path: '/empty',
          params: { 'foo' => 'bar', 'password' => '[FILTERED]' }
        )
      )
    end

    context 'with double_request_logs = false' do
      around do |example|
        Rails.application.config.epilog.double_request_logs = false
        example.run
        Rails.application.config.epilog.double_request_logs = true
      end

      it 'skips start log' do
        get(:index)
        expect(Rails.logger[2][3]).to include(
          message: 'GET /empty > 200 OK'
        )
      end
    end
  end

  describe RedirectController, type: :controller do
    it 'logs a redirect response' do
      get(:index)

      expect(Rails.logger[1][0]).to eq('INFO')
      expect(Rails.logger[1][3]).to match(
        message: 'Redirect > https://www.google.com',
        metrics: {
          duration: be_between(0, 40)
        }
      )
    end
  end

  describe DataController, type: :controller do
    render_views

    it 'logs a data response' do
      get(:index)

      expect(Rails.logger[2][0]).to eq('INFO')
      expect(Rails.logger[2][3]).to match(
        message: 'Sent data test.txt',
        metrics: {
          duration: be_between(0, 40)
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
          duration: be_between(0, 40)
        }
      )
    end
  end

  describe HaltController, type: :controller do
    render_views

    it 'logs a halted request' do
      get(:index)

      expect(Rails.logger[2][0]).to eq('INFO')
      expect(Rails.logger[2][3]).to match(
        message: 'Filter chain halted as :halt rendered or redirected',
        metrics: {
          duration: be_within(1).of(0)
        }
      )
    end
  end

  describe FragmentController, type: :controller do
    render_views

    it 'logs fragment caching in a request' do
      get(:index)

      logs = Rails.logger.to_a.select do |l|
        next unless l[3].is_a?(Hash)

        l[3][:message].match(/(read|write)_fragment/)
      end

      expect(logs[0][3]).to match(
        message: start_with('read_fragment views/'),
        metrics: {
          duration: be_between(0, 40)
        }
      )

      expect(logs[1][3]).to match(
        message: start_with('write_fragment views/'),
        metrics: {
          duration: be_between(0, 40)
        }
      )
    end
  end

  describe ErrorController, type: :controller do
    it 'resets context after request' do
      expect { get(:index) }.to raise_error('Something bad happened')
      Rails.logger.info('middle')
      expect { get(:index) }.to raise_error('Something bad happened')

      controller_log = [{ request: hash_including(path: '/error') }]
      expect(Rails.logger[0][4]).to match(controller_log)
      expect(Rails.logger[2][4]).to eq([])
      expect(Rails.logger[3][4]).to match(controller_log)
    end
  end

  if Rails::VERSION::MAJOR >= 5
    describe ApiController, type: :controller do
      it 'logs an API request' do
        get(:index)
        expect(Rails.logger[0][0]).to eq('INFO')
        expect(Rails.logger[0][3][:message]).to eq('GET /api started')
        expect(Rails.logger[1][3][:message]).to eq('GET /api > 200 OK')
      end
    end
  end
end
