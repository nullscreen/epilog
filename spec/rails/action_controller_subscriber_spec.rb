# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe Epilog::Rails::ActionControllerSubscriber do
  before { Timecop.freeze(Time.local(2017, 1, 10, 5, 0)) }
  after { Timecop.return }

  describe EmptyController, type: :controller do
    render_views

    it 'logs a normal GET request' do
      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
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

      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
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
          duration: be_within(1).of(0)
        }
      )

      get(:index)
    end

    it 'logs a request with unpermitted parameters' do
      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'GET /empty?foo=bar started',
        request: {
          method: 'GET',
          path: '/empty?foo=bar',
          params: { 'foo' => 'bar' },
          format: :html,
          controller: 'EmptyController',
          action: 'index'
        }
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'DEBUG',
        Time.now,
        'epilog',
        message: 'Unpermitted parameters: foo',
        metrics: {
          duration: be_within(1).of(0)
        }
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'GET /empty?foo=bar > 200 OK',
        request: {
          method: 'GET',
          path: '/empty?foo=bar',
          params: { 'foo' => 'bar' },
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
          duration: be_within(1).of(0)
        }
      )

      get(:index, foo: 'bar')
    end
  end

  describe RedirectController, type: :controller do
    it 'logs a redirect response' do
      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'GET /redirect started',
        request: {
          method: 'GET',
          path: '/redirect',
          params: {},
          format: :html,
          controller: 'RedirectController',
          action: 'index'
        }
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'Redirect > https://www.google.com',
        metrics: {
          duration: be_within(1).of(0)
        }
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'GET /redirect > 302 Found',
        request: {
          method: 'GET',
          path: '/redirect',
          params: {},
          format: :html,
          controller: 'RedirectController',
          action: 'index'
        },
        response: {
          status: 302
        },
        metrics: {
          db_runtime: 0,
          duration: be_within(1).of(0)
        }
      )

      get(:index)
    end
  end

  describe DataController, type: :controller do
    render_views

    it 'logs a data response' do
      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'GET /data started',
        request: {
          method: 'GET',
          path: '/data',
          params: {},
          format: :html,
          controller: 'DataController',
          action: 'index'
        }
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'Sent data test.txt',
        metrics: {
          duration: be_within(1).of(0)
        }
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'GET /data > 200 OK',
        request: {
          method: 'GET',
          path: '/data',
          params: {},
          format: :html,
          controller: 'DataController',
          action: 'index'
        },
        response: {
          status: 200
        },
        metrics: {
          db_runtime: 0,
          view_runtime: be_within(10).of(10),
          duration: be_within(1).of(0)
        }
      )

      get(:index)
    end
  end

  describe FileController, type: :controller do
    it 'logs a file response' do
      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'GET /file started',
        request: {
          method: 'GET',
          path: '/file',
          params: {},
          format: :html,
          controller: 'FileController',
          action: 'index'
        }
      )

      filename = File.join(Rails.root, 'public/test.txt')
      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: "Sent file #{filename}",
        metrics: {
          duration: be_within(1).of(0)
        }
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'GET /file > 200 OK',
        request: {
          method: 'GET',
          path: '/file',
          params: {},
          format: :html,
          controller: 'FileController',
          action: 'index'
        },
        response: {
          status: 200
        },
        metrics: {
          db_runtime: 0,
          duration: be_within(1).of(0)
        }
      )

      get(:index)
    end
  end

  describe HaltController, type: :controller do
    render_views

    it 'logs a halted request' do
      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'GET /halt started',
        request: {
          method: 'GET',
          path: '/halt',
          params: {},
          format: :html,
          controller: 'HaltController',
          action: 'index'
        }
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'Filter chain halted as :halt rendered or redirected',
        metrics: {
          duration: be_within(1).of(0)
        }
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'GET /halt > 200 OK',
        request: {
          method: 'GET',
          path: '/halt',
          params: {},
          format: :html,
          controller: 'HaltController',
          action: 'index'
        },
        response: {
          status: 200
        },
        metrics: {
          db_runtime: 0,
          view_runtime: be_within(10).of(10),
          duration: be_within(1).of(0)
        }
      )

      get(:index)
    end
  end

  describe FragmentController, type: :controller do
    render_views

    it 'logs fragment caching in a request' do
      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'GET /fragment started',
        request: {
          method: 'GET',
          path: '/fragment',
          params: {},
          format: :html,
          controller: 'FragmentController',
          action: 'index'
        }
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'DEBUG',
        Time.now,
        'epilog',
        '  Cache digest for app/views/fragment/index.html.erb: ' \
          'a95025bad961ccf31e377774190b64af'
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'DEBUG',
        Time.now,
        'epilog',
        '  Cache digest for app/views/fragment/_partial.html.erb: ' \
          '336d5ebc5436534e61d16e63ddfca327'
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'DEBUG',
        Time.now,
        'epilog',
        message: start_with('read_fragment views/'),
        metrics: {
          duration: be_within(1).of(0)
        }
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'DEBUG',
        Time.now,
        'epilog',
        message: start_with('write_fragment views/'),
        metrics: {
          duration: be_within(1).of(0)
        }
      )

      expect(Rails.logger.formatter).to receive(:call).with(
        'INFO',
        Time.now,
        'epilog',
        message: 'GET /fragment > 200 OK',
        request: {
          method: 'GET',
          path: '/fragment',
          params: {},
          format: :html,
          controller: 'FragmentController',
          action: 'index'
        },
        response: {
          status: 200
        },
        metrics: {
          db_runtime: 0,
          view_runtime: be_within(10).of(10),
          duration: be_within(1).of(0)
        }
      )

      get(:index)
    end
  end
end
