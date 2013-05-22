module SitePrism
  module Vcr
    class InitialAdjuster
      def initialize(options)
        @options = options
        @fixtures_handler = FixturesHandler.new(@options)
      end

      def fixtures(val)
        @fixtures_handler.add_fixtures(val)
      end

      def home_path(val)
        @options.home_path = val
      end

      def path(path, fixture_names)
        fixtures = []

        fixture_names.map do |name|
          fixtures << "#{path}/#{name}"
        end

        @fixtures_handler.add_fixtures(fixtures)
      end

      def waiter(val)
        @options.waiter = val
      end

      def prepared_fixtures
        Fixtures.new(@fixtures_handler.fixtures)
      end
    end
  end
end