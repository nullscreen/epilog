# frozen_string_literal: true

module Epilog
  class Logger < ::Logger
    include ContextLogger

    def initialize(*args, **options)
      super
      self.formatter = Formatter.new
    end

    def datetime_format
      return unless formatter

      formatter.datetime_format
    end

    def datetime_format=(format)
      return unless formatter

      formatter.datetime_format = format
    end
  end
end
