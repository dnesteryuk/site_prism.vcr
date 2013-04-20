module SitePrism
  module Vcr
    class FixturesHandler
      def initialize(options = {})
        @options = options

        @default_fixtures = Fixtures.new(options[:fixtures])
      end

      # TODO: create possibility to exchange fixtures
      # TODO: take a look at the tests, there are too many
      # this method should be refactored somehow
      def apply(custom_fixtures = [], behavior = :replace)
        custom_fixtures = [*custom_fixtures]

        @fixtures = if custom_fixtures.size > 0
          @default_fixtures.public_send(behavior, custom_fixtures)
        else
          @default_fixtures
        end

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
