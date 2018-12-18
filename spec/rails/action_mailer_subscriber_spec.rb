# frozen_string_literal: true

# rubocop:disable BlockLength
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
        duration: be_between(0, 200)
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

  it 'logs receiving mail' do
    TestMailer.receive(Mail.new(body: 'test mail').to_s)

    expect(Rails.logger[0][0]).to eq('INFO')
    expect(Rails.logger[0][3]).to match(
      message: 'Received mail',
      body: include('test mail'),
      metrics: {
        duration: be_between(0, 10)
      }
    )
  end
end
# rubocop:enable BlockLength
