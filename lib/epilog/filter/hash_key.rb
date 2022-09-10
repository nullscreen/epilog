# frozen_string_literal: true

module Epilog
  module Filter
    class HashKey
      def call(log)
        fix(log)
      end

      private

      def fix(value)
        case value
        when Hash
          fix_hash(value)
        when Array
          value.map { |i| fix(i) }
        else
          value
        end
      end

      def fix_hash(hash)
        hash.each_with_object({}) do |(key, value), obj|
          obj[key] = if key?(key)
            filter(value)
          else
            fix(value)
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
