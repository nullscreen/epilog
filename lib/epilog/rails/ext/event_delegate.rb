# frozen_string_literal: true

module Epilog
  module EventDelegateExt
    # Rails has no public API to determine the delegate for an event
    # object. Add this method to allow checking if the delegate matches
    # a given object.
    def delegates_to?(delegate)
      @delegate == delegate
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
