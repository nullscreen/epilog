# frozen_string_literal: true

class HaltController < ActionController::Base
  before_filter :halt

  def index
  end

  private

  def halt
    render text: ''
  end
end
