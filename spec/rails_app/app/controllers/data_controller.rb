# frozen_string_literal: true
class DataController < ActionController::Base
  def index
    send_data(
      File.open(File.join(Rails.root, 'public/test.txt')),
      type: 'text/plain',
      filename: 'test.txt'
    )
  end
end
