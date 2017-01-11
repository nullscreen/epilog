# frozen_string_literal: true
class FileController < ActionController::Base
  def index
    send_file(
      File.join(Rails.root, 'public/test.txt'),
      type: 'text/plain'
    )
  end
end
