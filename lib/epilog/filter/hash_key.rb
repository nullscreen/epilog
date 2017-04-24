# frozen_string_literal: true

module Epilog
  module Filter
    class HashKey
      def call(log)
        fix(log)
      end

      private

      def fix(hash)
        hash.each_with_object({}) do |(key, value), obj|
          obj[key] = if key?(key)
            filter(value)
          elsif value.is_a?(Hash)
            fix(value)
          else
            value
          end
        end
      end

      def key?(_key)
        true
      end

      def filter(value)
        "[filtered #{value.class.name}]"
      end
    end
  end
end
