# TODO: create possibility to exchange fixtures
module SitePrism
  module Vcr
    class Adjuster
      include SitePrism::Vcr::PathCombiner

      def initialize(fixtures_handler, options)
        @fixtures_handler = fixtures_handler
        @action, @waiter  = :replace, options.waiter
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
        @fixtures_handler.apply(fixtures, @action)
      end
    end
  end
end