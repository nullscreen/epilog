# frozen_string_literal: true

module Epilog
  module EventDelegateExt
    # Rails has no public API to determine the delegate for an event
    # object. Add these methods to allow checking the delegate.
    def delegate
      @delegate
    end

    def delegates_to?(other)
      @delegate == other
    end
  end
end

# @api external
module ActiveSupport
  module Notifications
    class Fanout
      module Subscribers
        class Evented
          include Epilog::EventDelegateExt
        end
      end
    end
  end
end
