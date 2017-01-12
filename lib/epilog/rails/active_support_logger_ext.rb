module ActiveSupport
  class Logger
    def self.broadcast(*args)
      Module.new
    end
  end
end
