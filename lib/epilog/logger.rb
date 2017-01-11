# frozen_string_literal: true
module Epilog
  class Logger < ::Logger
    def initialize(logdev, shift_age = 0, shift_size = 1_048_576)
      super(
        logdev,
        shift_age,
        shift_size
      )

      self.formatter = Formatter.new
    end

    def datetime_format
      formatter.datetime_format
    end

    def datetime_format=(format)
      formatter.datetime_format = format
    end
  end
end
