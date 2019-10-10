# frozen_string_literal: true

class ErrorController < ActionController::Base
  def index
    raise 'Something bad happened'
  end
end
