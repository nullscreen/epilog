# frozen_string_literal: true
module Epilog
  module EventDelegateExt
    def delegates_to?(delegate)
      @delegate == delegate
    end
  end
end

ActiveSupport::Notifications::Fanout::Subscribers::Evented.include(
  Epilog::EventDelegateExt
)
