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
        fixtures, wrong_fixtures = [], []

        fixture_names.map do |name|
          if name[0..1] == '~/'
            wrong_fixtures << name[2..-1]
          else
            fixtures << "#{path}/#{name}"
          end
        end

        if wrong_fixtures.length > 0
          prepared_names = wrong_fixtures.join("', '")

          raise ArgumentError.new(
            "You cannot use the home path while listing fixtures in the 'path' method. " <<
            "Please, use 'fixtures' method for '#{wrong_fixtures.join(', ')}' fixtures or " <<
            "you can additionally use the 'path' method where you will specify a home path as a path name." <<
            "Example: path('~/', ['#{prepared_names}'])"
          )
        end

        @fixtures_handler.add_fixtures(fixtures)
      end

      # TODO: think how to manage the situation when both are passed
      def waiter(waiter_method = nil, &block)
        @options.waiter = if block_given?
          block
        else
          waiter_method
        end
      end

      def prepared_fixtures
        Fixtures.new(@fixtures_handler.fixtures)
      end
    end
  end
end