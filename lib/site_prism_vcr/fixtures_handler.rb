module SitePrism
  module Vcr
    class FixturesHandler
      def initialize(options)
        @options = options

        # Assigns default cassettes which will be used if no custom are passed
        # while applying them.
        @default_fixtures = Fixtures.new(@options.fixtures)
      end

      def apply(custom_fixtures = [], behavior = :replace)
        custom_fixtures = [*custom_fixtures]

        @fixtures = @default_fixtures.public_send(
          behavior, custom_fixtures
        )

        inject
      end

      private
        def inject
          raise ArgumentError.new(
            'No fixtures were specified to insert them into VCR'
          ) if @fixtures.size == 0

          @fixtures.map do |fixture|
            VCR.insert_cassette fixture
          end
        end
    end
  end
end
