module SitePrism
  module Vcr
    class FixturesHandler
      attr_reader :fixtures

      def initialize(default_fixtures = [])
        @fixtures = Fixtures.new(default_fixtures)
      end

      # TODO: create possibility to exchange fixtures
      def apply(custom_fixtures = [], behavior = :replace)
        custom_fixtures = [*custom_fixtures]

        if custom_fixtures.size > 0
          @fixtures = @fixtures.public_send(behavior, custom_fixtures)
        end

        inject
      end

      private
        def inject
          raise ArgumentError.new(
            'No fixtures were specified to insert them into VCR'
          ) if fixtures.size == 0

          fixtures.map do |fixture|
            VCR.insert_cassette fixture
          end
        end
    end
  end
end
