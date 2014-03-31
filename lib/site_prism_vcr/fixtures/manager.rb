module SPV
  class Fixtures
    # Takes cares about inserting and ejecting fixtures
    # from Vcr.
    class Manager
      def initialize(options)
        @options = options
      end

      # Injects given fixtures to Vcr.
      #
      # @param fixtures [SPV::Fixtures] List of fixtures.
      #
      # @return [void]
      #
      # @raise [ArgumentError] If a list of fixtures is empty.
      def inject(fixtures)
        raise ArgumentError.new(
          'No fixtures were specified to insert them into VCR'
        ) if fixtures.size == 0

        fixtures.each do |fixture|
          VCR.insert_cassette fixture.name, fixture.options
        end
      end

      # Ejects all fixtures from Vcr.
      # Now it doesn't care which fixtures were inserted by
      # an instance of this class. After calling this method
      # Vcr will have no inserted fixtures at all.
      #
      # @return [void]
      def eject
        SPV::Helpers.eject_all_cassettes
      end
    end # class Manager
  end # class Fixtures
end # module SPV
