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

ActiveSupport::Notifications::Fanout::Subscribers::Evented.include(
  Epilog::EventDelegateExt
)
