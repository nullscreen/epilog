# frozen_string_literal: true

module Epilog
  module Filter
    class FilterParameters < Blacklist
      private

      def filter_parameters
        return @filter_parameters if @filter_parameters

        filtered = Hash[
          ::Rails.application.config.filter_parameters.map do |p|
            [p.to_s.downcase, true]
          end
        ]

        @filter_parameters = filtered if ::Rails.initialized?
        filtered
      end

      def key?(key)
        filter_parameters.key?(key.to_s.downcase)
      end
    end
  end
end
