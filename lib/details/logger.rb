module Details
  class Logger < ::Logger
    def initialize
      super
      self.formatter = Formatter.new
    end
  end
end
