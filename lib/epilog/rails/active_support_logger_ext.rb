# frozen_string_literal: true
module ActiveSupport
  class Logger
    def self.broadcast(*_args)
      Module.new
    end
  end
end
