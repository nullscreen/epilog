# frozen_string_literal: true

RSpec.describe Epilog::Rails::ActionMailerSubscriber, type: :controller do
  render_views

  it 'logs sending mail' do
    TestMailer.test.deliver_now

    expect(Rails.logger[1][0]).to eq('DEBUG')
    expect(Rails.logger[1][3]).to match(
      message: 'Processed outbound mail',
      action: :test,
      mailer: 'TestMailer',
      metrics: {
        duration: be_between(0, 500)
      }
    )

    expect(Rails.logger[2][0]).to eq('INFO')
    expect(Rails.logger[2][3]).to match(
      message: 'Sent mail',
      recipients: ['user@example.com'],
      body: include('My mail message!'),
      metrics: {
        duration: be_between(0, 20)
      }
    )
  end

  # Method `receive` removed in Rails 6.1
  # https://github.com/rails/rails/commit/d5fa9569a0d401893d54ee47fe43fd87b6155fb7
  if Gem::Version.new(Rails::VERSION::STRING) < Gem::Version.new('6.1.0')
    it 'logs receiving mail' do
      TestMailer.receive(Mail.new(body: 'test mail').to_s)

      expect(Rails.logger[0][0]).to eq('INFO')
      expect(Rails.logger[0][3])
        .to match(
          message: 'Received mail',
          body: include('test mail'),
          metrics: {
            duration: be_between(0, 20)
          }
        )
    end
  end
end
