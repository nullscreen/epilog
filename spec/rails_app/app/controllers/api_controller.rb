# frozen_string_literal: true

if defined? ActionController::API
  class ApiController < ActionController::API
    def index
      render json: {}
    end
  end
end
