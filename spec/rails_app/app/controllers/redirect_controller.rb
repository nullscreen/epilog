# frozen_string_literal: true

class RedirectController < ActionController::Base
  def index
    redirect_to 'https://www.google.com', allow_other_host: true
  end
end
