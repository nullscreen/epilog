# frozen_string_literal: true

class EmptyController < ActionController::Base
  def index
    params.permit(:id)
    render plain: ''
  end

  def epilog_context
    {
      custom: 'custom context'
    }
  end
end
