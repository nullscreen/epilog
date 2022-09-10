# frozen_string_literal: true

module Epilog
  module Filter
    class Blacklist < HashKey
      DEFAULT_BLACKLIST = %w[
        password
        pass
        pw
        secret
      ].freeze

      attr_reader :blacklist

      def initialize(blacklist = DEFAULT_BLACKLIST)
        @blacklist = blacklist.map { |b| [b.to_s.downcase, nil] }.to_h
        super()
      end

      private

      def key?(key)
        @blacklist.key?(key.to_s.downcase)
      end

      def filter(value)
        "[filtered #{value.class.name}]"
      end
    end
  end
end
