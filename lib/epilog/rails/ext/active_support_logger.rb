# frozen_string_literal: true

if ::Rails.gem_version < Gem::Version.new('7.1')
  module ActiveSupport
    class Logger
      # Rails uses this method to attach additional loggers to the main
      # Rails.logger object when using the rails console or server. This results
      # in extra unformatted log output in those cases. Prevent that by
      # overriding the method with a stub. Examples can be found in
      #
      # - railties/lib/rails/commands/server.rb
      # - active_record/lib/active_record/railtie.rb
      def self.broadcast(*_args)
        Module.new
      end
    end
  end
end
