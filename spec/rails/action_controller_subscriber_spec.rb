# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe Epilog::Rails::ActionControllerSubscriber do
  def params(values)
    Rails::VERSION::MAJOR >= 5 ? { params: values } : values
  end

  describe EmptyController, type: :controller do
    render_views

    it 'logs a normal GET request' do
      get(:index)

      expect(Rails.logger[0][0]).to eq('INFO')
      expect(Rails.logger[0][3]).to match(
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

      expect(Rails.logger[2][0]).to eq('INFO')
      expect(Rails.logger[2][3]).to match(
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
          db_runtime: 0,
          view_runtime: be_within(10).of(10),
          request_runtime: be_between(0, 20)
        }
      )
    end

    it 'logs a request with unpermitted parameters' do
      get(:index, params(foo: 'bar'))

      expect(Rails.logger[1][0]).to eq('DEBUG')
      expect(Rails.logger[1][3]).to match(
        message: 'Unpermitted parameters: foo',
        metrics: {
          duration: be_between(0, 20)
        }
      )
    end

    it 'removes default Rails params' do
      get(:index, params(foo: 'bar', password: 'secret'))

      expect(Rails.logger[0][3]).to match(hash_including(
        request: hash_including(
          params: { 'foo' => 'bar', 'password' => '[FILTERED]' }
        )
      ))
    end
  end

  describe RedirectController, type: :controller do
    it 'logs a redirect response' do
      get(:index)

      expect(Rails.logger[1][0]).to eq('INFO')
      expect(Rails.logger[1][3]).to match(
        message: 'Redirect > https://www.google.com',
        metrics: {
          duration: be_between(0, 20)
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
          duration: be_between(0, 20)
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
          duration: be_between(0, 20)
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
          duration: be_between(0, 20)
        }
      )

      expect(logs[1][3]).to match(
        message: start_with('write_fragment views/'),
        metrics: {
          duration: be_between(0, 20)
        }
      )
    end
  end
end
# rubocop:enable Metrics/BlockLength
