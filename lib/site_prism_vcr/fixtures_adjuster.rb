module SitePrism
  module Vcr
    class FixturesAdjuster
      attr_reader :fixtures

      def initialize(fixtures_handler)
        @fixtures_handler, @fixtures = fixtures_handler, []
        @action = :replace
      end

      def path(path, fixture_names)
        fixture_names.map do |name|
          @fixtures << "#{path}/#{name}"
        end
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