# frozen_string_literal: true

module ActionDispatch
  class DebugExceptions
    private

    def log_error(env, wrapper)
      logger = logger(env)
      return unless logger.is_a?(Epilog::Logger)

      if wrapper.status_code == 500
        logger.fatal(wrapper.exception)
      else
        logger.warn(wrapper.exception)
      end
    end
  end
end
