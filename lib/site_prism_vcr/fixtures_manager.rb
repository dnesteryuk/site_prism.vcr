module SitePrism
  module Vcr
    class FixturesManager
      def initialize(options)
        @options = options
      end

      def inject(fixtures)
        raise ArgumentError.new(
          'No fixtures were specified to insert them into VCR'
        ) if fixtures.size == 0

        fixtures.map do |fixture|
          VCR.insert_cassette fixture
        end
      end

      # TODO: the way to eject only fixtures which were inserted
      # by a particular handler
      def eject
        while VCR.eject_cassette
        end
      end
    end
  end
end
