# frozen_string_literal: true

class TestMailer < ActionMailer::Base
  default from: 'test@example.com'
  layout 'mailer'

  def test
    mail(to: 'user@example.com', subject: 'Email test')
  end

  def receive(_email)
  end
end
