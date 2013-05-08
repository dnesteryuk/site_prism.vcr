# TODO: create possibility to exchange fixtures
module SitePrism
  module Vcr
    class Adjuster < InitialAdjuster
      def initialize(options, fixtures_handler)
        @options, @fixtures_handler = options, fixtures_handler
        @action, @waiter = :replace, options.waiter
      end

      def waiter(val = nil)
        if val.nil?
          @waiter
        else
          @waiter = val
        end
      end

      def replace
        @action = :replace
      end

      def union
        @action = :union
      end

      def modify_fixtures
        @fixtures_handler.apply(@options.fixtures, @action)
      end
    end
  end
end