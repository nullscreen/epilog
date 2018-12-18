# frozen_string_literal: true

module Epilog
  module Rails
    class ActionViewSubscriber < LogSubscriber
      def render_template(event)
        info { hash(event, 'Rendered template') }
      end

      def render_partial(event)
        info { hash(event, 'Rendered partial') }
      end

      def render_collection(event)
        info { hash(event, 'Rendered collection') }
      end

      private

      def hash(event, message)
        {
          message: message,
          template: fix_path(event.payload[:identifier]),
          layout: fix_path(event.payload[:layout]),
          metrics: {
            duration: event.duration.round(2)
          }
        }
      end

      def fix_path(template)
        return if template.nil?

        base = File.join(::Rails.root, 'app', 'views', '')
        pattern = /^#{Regexp.escape(base)}/
        template.gsub(pattern, '')
      end
    end
  end
end
