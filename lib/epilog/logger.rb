# frozen_string_literal: true
module Epilog
  class Logger < ::Logger
    def initialize(*args, **options)
      super
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
