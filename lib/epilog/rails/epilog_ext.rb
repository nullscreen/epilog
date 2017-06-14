# frozen_string_literal: true

module Epilog
  class Logger
    include LoggerSilence

    def silencer
      false
    end
  end
end
