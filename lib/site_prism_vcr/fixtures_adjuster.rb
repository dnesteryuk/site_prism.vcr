module SitePrism
  module Vcr
    class FixturesAdjuster
      attr_reader :fixtures

      def initialize(fixtures_handler)
        @fixtures_handler, @fixtures = fixtures_handler, []
      end

      def path(path, fixture_names)
        fixture_names.map do |name|
          @fixtures << "#{path}/#{name}"
        end
      end

      def replace
        @fixtures_handler.apply(fixtures, :replace)
      end

      def union
        @fixtures_handler.apply(fixtures, :union)
      end
    end
  end
end