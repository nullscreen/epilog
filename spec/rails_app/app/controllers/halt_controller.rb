# frozen_string_literal: true

class HaltController < ActionController::Base
  before_action :halt

  def index
  end

  private

  def halt
    render plain: ''
  end
end
