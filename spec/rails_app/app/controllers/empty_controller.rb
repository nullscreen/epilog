# frozen_string_literal: true

class EmptyController < ActionController::Base
  def index
    params.permit(:id)
    Rails.logger.info('test log')
    render plain: ''
  end

  def epilog_context
    {
      custom: 'custom context'
    }
  end
end
